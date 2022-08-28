import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../components/buttons.dart';
import '../../constants.dart';
import '../../screens/policy_screen/privacy_policy.dart';
import '../../screens/policy_screen/terms_of_service.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(); // gets email address value
  final passController = TextEditingController(); // gets password value

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);
    bool absorbing = currTheme.absorbing;
    TextStyle style = TextStyle(
        fontSize: 12.0,
        color: Provider.of<Auth>(context, listen: true).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Roboto');
    TextStyle btnStyle = const TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        letterSpacing: 0.5,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold);

    //Decoration for textfields
    InputDecoration inputFieldDecorate(labelText, IconData prefixIcon) {
      return InputDecoration(
          fillColor: Provider.of<Auth>(context, listen: true).darkTheme
              ? PRIMARY_DARK
              : Colors.white,
          filled: true,
          prefixIcon: Icon(prefixIcon, color: PRIMARY_BLUE),
          focusColor: PRIMARY_BLUE,
          border: const OutlineInputBorder(),
          labelStyle: style,
          labelText: labelText);
    }

    // Input field for email address
    final Widget emailField = TextFormField(
        controller: emailController,
        obscureText: false,
        style: style,
        autofillHints: const [AutofillHints.email],
        validator: (value) =>
            value!.isEmpty ? "Please enter your email!" : null,
        decoration: inputFieldDecorate("Email address", Icons.email));

    // Input field for password
    final Widget passField = TextFormField(
        controller: passController,
        obscureText: true,
        autocorrect: false,
        style: style,
        autofillHints: const [AutofillHints.password],
        validator: (value) =>
            value!.isEmpty ? "Please enter your password!" : null,
        decoration: inputFieldDecorate("Password", Icons.vpn_key));

    Future<void> onLogin() async {
      // details to log in
      String? deviceModel = await getDeviceModel();

      Map creds = {
        "email": emailController.text.trim(),
        "password": passController.text,
        "device_name": deviceModel
      };

      if (_formKey.currentState!.validate()) {
        // Login process
        Provider.of<Auth>(context, listen: false)
            .loginUser(context, creds: creds);
      }
    }

    void showMessage(String message) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    // Login Button
    final Widget loginButton = buildButton(
        context, PRIMARY_BLUE, "Sign In", btnStyle, onLogin, PRIMARY_DARK);

    final Widget googleSignInButton = buildButton(
        context, PRIMARY_BLUE, "Sign in with Google", btnStyle, () async {
      await Provider.of<Auth>(context, listen: false)
          .loginWithGoogle(context, showMessage);
    }, PRIMARY_DARK);

    // Go to register screen button
    final Widget createNewAccountButton =
        buildOutlinedButton(context, "Create New Account", btnStyle, () {
      Navigator.pushNamed(context, '/register');
    }, PRIMARY_BLUE);

    TextStyle appbarStyle = const TextStyle(
        fontSize: 24.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    return WillPopScope(
        onWillPop: null,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(
                color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
              ),
              title: Text("Login",
                  style: appbarStyle.copyWith(
                      fontSize: 16,
                      color:
                          currTheme.darkTheme ? Colors.white : PRIMARY_DARK)),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SingleChildScrollView(
                        child: AbsorbPointer(
                            absorbing: absorbing,
                            child: Opacity(
                                opacity: absorbing ? 0.5 : 1.0,
                                child: Form(
                                    key: _formKey,
                                    child: AutofillGroup(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 60,
                                          height: 120,
                                          child:
                                              Image.asset('images/ideas.png'),
                                        ),
                                        Text("Sign in or Create a New Account",
                                            textAlign: TextAlign.center,
                                            style: style.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 30.0),
                                        emailField,
                                        const SizedBox(height: 18.0),
                                        passField,
                                        const SizedBox(height: 5.0),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: RichText(
                                              textAlign: TextAlign.right,
                                              text: TextSpan(
                                                  text: "Forgot Password?",
                                                  style: const TextStyle(
                                                      color: LIGHT_GREY,
                                                      fontSize: 12),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/reset-password');
                                                        })),
                                        ),
                                        const SizedBox(
                                          height: 35.0,
                                        ),
                                        loginButton,
                                        const SizedBox(height: 15.0),
                                        googleSignInButton,
                                        const SizedBox(height: 15.0),
                                        createNewAccountButton,
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
                                                              "By logging in you are agreeing with our"),
                                                      TextSpan(
                                                          text:
                                                              " Privacy Policy ",
                                                          style: const TextStyle(
                                                              color:
                                                                  PRIMARY_BLUE),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              const PrivacyPolicyScreen(),
                                                                          type:
                                                                              PageTransitionType.rightToLeftWithFade));
                                                                }),
                                                      const TextSpan(text: "&"),
                                                      TextSpan(
                                                          text:
                                                              " Terms of Service ",
                                                          style: const TextStyle(
                                                              color:
                                                                  PRIMARY_BLUE),
                                                          recognizer:
                                                              TapGestureRecognizer()
                                                                ..onTap = () {
                                                                  Navigator.push(
                                                                      context,
                                                                      PageTransition(
                                                                          child:
                                                                              const TermsOfServiceScreen(),
                                                                          type:
                                                                              PageTransitionType.rightToLeftWithFade));
                                                                }),
                                                    ],
                                                    style: style.copyWith(
                                                      fontSize: 14,
                                                    ))))
                                      ],
                                    ))))))))));
  }
}
