import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../components/buttons.dart';
import '../../screens/login_screen/validate_login.dart';
import '../../constants.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(); // gets full name value
  final emailController = TextEditingController(); // gets email address value
  final passController = TextEditingController(); // gets password value
  final confirmPassController =
      TextEditingController(); // gets password confirmation value
  bool _isEmailUsed = false;
  late String _emailError;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  // snackBar Widget
  snackBar(String message, {Color bgColor = PRIMARY_DARK}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: bgColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: 12.0,
      color: Provider.of<Auth>(context, listen: false).darkTheme
          ? Colors.white
          : PRIMARY_DARK,
      fontFamily: 'Roboto',
    );
    TextStyle btnStyle = const TextStyle(
        color: Colors.white,
        fontSize: 13.0,
        letterSpacing: 0.25,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold);

    //Decoration for textfields
    InputDecoration inputFieldDecorate(labelText, IconData prefixIcon) {
      return InputDecoration(
          fillColor: Provider.of<Auth>(context, listen: false).darkTheme
              ? PRIMARY_DARK
              : Colors.white,
          filled: true,
          prefixIcon: Icon(prefixIcon, color: Colors.indigoAccent),
          focusColor: PRIMARY_BLUE,
          border: const OutlineInputBorder(),
          labelStyle: style,
          labelText: labelText,
          errorMaxLines: 2);
    }

    final Widget nameField = TextFormField(
        controller: nameController,
        obscureText: false,
        style: style,
        validator: (value) =>
            value!.isEmpty ? "Please enter you full name!" : null,
        decoration: inputFieldDecorate("Full Name", Icons.badge));

    // Input field for email address
    final Widget emailField = TextFormField(
        controller: emailController,
        obscureText: false,
        style: style,
        validator: (value) => !validateEmail(value!.trim())
            ? "Please enter a valid email!"
            : _isEmailUsed
                ? _emailError
                : null,
        decoration: inputFieldDecorate("Email address", Icons.email));

    // Input field for password
    final Widget passField = TextFormField(
        controller: passController,
        obscureText: true,
        autocorrect: false,
        style: style,
        validator: (value) => !validatePassword(value!.trim())
            ? "Password must have atleast 8 characters!"
            : null,
        decoration: inputFieldDecorate("Password", Icons.vpn_key));

    // Input field for password
    final Widget confirmPassField = TextFormField(
        controller: confirmPassController,
        obscureText: true,
        autocorrect: false,
        style: style,
        validator: (value) => value!.isEmpty
            ? "Please confirm your password!"
            : value != passController.text
                ? "Passwords do not match!"
                : null,
        decoration:
            inputFieldDecorate("Confirm Password", Icons.confirmation_num));

    Future<void> onSignUp() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final provider = Provider.of<Auth>(context, listen: false);
      String? deviceModel = await getDeviceModel();

      Map creds = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passController.text,
        "password_confirmation": passController.text,
        "device_name": deviceModel
      };

      setState(() {
        _isEmailUsed = false;
      });

      if (_formKey.currentState!.validate()) {
        scaffoldMessenger.removeCurrentSnackBar();
        scaffoldMessenger
            .showSnackBar(showLoadingSnackbar("Processing request"));
        try {
          Response response = await dio().post('/register', data: creds);
          String token = response.data.toString();
          // ignore: use_build_context_synchronously
          provider.loginUser(context, token: token);
        } on DioError catch (e) {
          if (e.response!.statusCode == 422) {
            final errors = e.response!.data['errors'];
            if (errors != null && errors['email'] != null) {
              scaffoldMessenger.removeCurrentSnackBar();
              setState(() {
                _isEmailUsed = true;
                _emailError = errors['email'][0];
              });
              _formKey.currentState!.validate();
              return;
            }
          }
          if (kDebugMode) {
            print(e.response);
          }
          scaffoldMessenger.removeCurrentSnackBar();
          scaffoldMessenger.showSnackBar(const SnackBar(
            content: Text("Error while creating user!"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      }
    }

    // Login Button
    final Widget registerButton = buildButton(context, PRIMARY_BLUE,
        "Create Account", btnStyle, onSignUp, PRIMARY_DARK);

    // Go to register button
    final Widget signInButton = buildOutlinedButton(
        context, "Sign In With Existing Account", btnStyle, () {
      Navigator.pushNamed(context, '/login');
    }, PRIMARY_BLUE);

    TextStyle appbarStyle = const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Sign up", style: appbarStyle.copyWith(fontSize: 16)),
          backgroundColor: PRIMARY_BLUE,
          elevation: 0,
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 60,
                              height: 120,
                              child: Image.asset('images/ideas.png'),
                            ),
                            Text("Create a New Account",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 30.0),
                            nameField,
                            const SizedBox(height: 18.0),
                            emailField,
                            const SizedBox(height: 18.0),
                            passField,
                            const SizedBox(height: 18.0),
                            confirmPassField,
                            const SizedBox(
                              height: 35.0,
                            ),
                            registerButton,
                            const SizedBox(height: 15.0),
                            signInButton,
                            const SizedBox(height: 15.0),
                            Container(
                                margin: const EdgeInsets.fromLTRB(
                                    50.0, 0, 50.0, 25.0),
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        children: [
                                          const TextSpan(
                                              text:
                                                  "By creating an account you are agreeing with our"),
                                          TextSpan(
                                              text: " Privacy Policy ",
                                              style: const TextStyle(
                                                  color: PRIMARY_BLUE),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {}),
                                          const TextSpan(text: "&"),
                                          TextSpan(
                                              text: " Terms of Service ",
                                              style: const TextStyle(
                                                  color: PRIMARY_BLUE),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {}),
                                        ],
                                        style: style.copyWith(
                                          fontSize: 14,
                                        ))))
                          ],
                        ))))));
  }
}
