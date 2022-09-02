import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:prashna_app/models/set.dart';
import 'package:prashna_app/screens/discover_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prashna_app/models/user.dart';
import 'package:prashna_app/screens/login_screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'api.dart';
import 'globals.dart';

class Auth extends ChangeNotifier {
  LocalStorage localStorage = LocalStorage();
  static final Future<SharedPreferences> _storage =
      SharedPreferences.getInstance();
  bool _darkTheme = false;
  bool _isLoggedIn = false;
  bool _isLoggedInFromGoogle = false;
  User? _user;
  String? _error;
  String? _token;
  bool _absorbing = false;
  List<Set> _recommendedSets = [];
  String? _ip;

  bool get authenticated => _isLoggedIn;

  bool get loggedInWithGoogle => _isLoggedInFromGoogle;

  User? get user => _user;

  String? get error => _error;

  bool get absorbing => _absorbing;

  String? get token => _token;

  bool get darkTheme => _darkTheme;

  List<Set> get recommendedSets => _recommendedSets;

  String? get ip => _ip;

  set darkTheme(bool value) {
    _darkTheme = value;
    localStorage.setDarkTheme(value);
    notifyListeners();
  }

  set recommendedSets(List<Set> value) {
    _recommendedSets = value;
    notifyListeners();
  }

  set absorbing(bool value) {
    _absorbing = value;
    notifyListeners();
  }

  set ip(String? value) {
    _ip = value;
    notifyListeners();
  }

  Future<void> authenticate(Map creds) async {
    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      String token = response.data.toString();
      await authWithToken(token);
    } on Dio.DioError catch (e) {
      _error = e.response?.statusCode == 422
          ? "Email and password do not match!"
          : "Error logging in!";
    }
  }

  Future<void> authWithToken(String? token) async {
    final SharedPreferences storage = await _storage;
    try {
      if (token != null && token.isNotEmpty) {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        _isLoggedIn = true;
        _isLoggedInFromGoogle = false;
        _token = token;
        storeToken(token: token);
        storage.setBool("authenticated", true);
        Map<String, dynamic> user = response.data;
        _user = User.fromJson(user);
        notifyListeners();
      } else {
        throw Dio.DioErrorType.connectTimeout;
      }
    } on Dio.DioError catch (e) {
      if (kDebugMode) {
        print(e);
        print(e.response);
      }
      _error = e.response?.statusCode == 401
          ? "Session expired!"
          : "Connection Error!";
    }
  }

  Future<void> loginUser(BuildContext context,
      {Map? creds, String? token}) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    _absorbing = true;
    notifyListeners();
    ScaffoldMessenger.of(context)
        .showSnackBar(showLoadingSnackbar("Logging in"));

    if (token != null && token.isNotEmpty) {
      await authWithToken(token);
    } else {
      await authenticate(creds!);
    }
    afterLoginInfo(context);
  }

  Future<fb.UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().catchError((error) {
      if (kDebugMode) {
        print('Signin cancelled');
      }
    });

    if (googleUser == null) {
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = fb.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await fb.FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> loginWithGoogle(
      BuildContext context, Function showMessage) async {
    final mess = ScaffoldMessenger.of(context);
    _absorbing = true;
    notifyListeners();
    mess.removeCurrentSnackBar();
    mess.showSnackBar(showLoadingSnackbar("Logging in"));
    try {
      await signInWithGoogle();
      fb.User? user = fb.FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String deviceModel = await getDeviceModel();

        Map creds = {
          "uid": user.uid,
          "name": user.displayName,
          "email": user.email,
          "device_name": deviceModel,
          "avatar": user.photoURL,
          "type": 1
        };

        Dio.Response response = await dio().post('/register', data: creds);
        String token = response.data.toString();
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        await fb.FirebaseAuth.instance.signOut();
        loginUser(context, token: token);
      } else {
        _absorbing = false;
        notifyListeners();
        mess.removeCurrentSnackBar();
      }
    } on Dio.DioError catch (e) {
      _absorbing = false;
      notifyListeners();
      if (e.response!.statusCode == 422) {
        final errors = e.response!.data['errors'];
        if (errors != null && errors['email'] != null) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text("Email is already registered!"),
            backgroundColor: Colors.red[400],
            duration: const Duration(seconds: 2),
          ));
          return;
        }
      }
      if (kDebugMode) {
        print(e.response);
      }
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error while logging in!"),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ));
    } catch (e) {
      if (e is fb.FirebaseAuthException) {
        showMessage(e.message!);
      }
    }
  }

  void afterLoginInfo(BuildContext context) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    _absorbing = false;
    notifyListeners();
    if (_isLoggedIn) {
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              settings: const RouteSettings(name: "Home"),
              builder: (context) => const MainScreen()));
    } else if (!_isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_error!),
        backgroundColor: Colors.red,
      ));
    } // show error if not authenticated
  }

  void storeToken({required String token}) async {
    final SharedPreferences storage = await _storage;
    storage.setString('token', token);
  }

  Future<void> logoutUser(BuildContext context) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    _absorbing = true;
    notifyListeners();
    ScaffoldMessenger.of(context)
        .showSnackBar(showLoadingSnackbar("Logging out"));
    logout(context);
  }

  Future<void> logout(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanup();
      notifyListeners();
      scaffoldMessenger.removeCurrentSnackBar();
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text('Successfully logged out!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ));
      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      _error = "Error logging out!";
    }
  }

  void cleanup() async {
    _absorbing = false;
    _token = null;
    _isLoggedIn = false;
    _isLoggedInFromGoogle = false;
    _user = null;
    final SharedPreferences storage = await _storage;
    storage.setBool("authenticated", false);
    if (storage.containsKey('token')) storage.remove('token');
  }

  Future<void> refreshUser() async {
    final SharedPreferences storage = await _storage;
    final token = storage.get('token');
    Dio.Response response = await dio().get('/user',
        options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
    _user = User.fromJson(response.data);
    notifyListeners();
  }
}
