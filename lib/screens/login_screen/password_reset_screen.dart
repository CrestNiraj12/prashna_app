import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../components/buttons.dart';
import '../../constants.dart';
import '../../screens/login_screen/code_verification_screen.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:provider/provider.dart';

class PasswordResetScreen extends StatefulWidget {
  PasswordResetScreen({Key? key}) : super(key: key);
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(); // gets email address value

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  Future<bool> verifyEmail(Map data) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(showLoadingSnackbar("Verifying email"));
      await dio().post('/forgot-password', data: data);
      return true;
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response!.data['errors']['email'][0] ??
            e.response!.data['message']),
        backgroundColor: Colors.red,
      ));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontSize: 14.0,
        color: Provider.of<Auth>(context, listen: true).darkTheme
            ? Colors.white
            : PRIMARY_DARK);
    TextStyle btnStyle = const TextStyle(
        color: Colors.white,
        fontSize: 12.0,
        letterSpacing: 0.5,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold);

    //Decoration for textfields
    InputDecoration inputFieldDecorate(labelText, prefixIcon) {
      return InputDecoration(
          fillColor: Provider.of<Auth>(context, listen: true).darkTheme
              ? PRIMARY_DARK
              : Colors.white,
          filled: true,
          prefixIcon: Icon(
            prefixIcon,
            color: PRIMARY_BLUE,
          ),
          focusColor: PRIMARY_BLUE,
          border: OutlineInputBorder(),
          labelStyle: style,
          labelText: labelText,
          errorMaxLines: 2);
    }

    // Input field for email address
    final Widget emailField = TextFormField(
        controller: emailController,
        obscureText: false,
        style: style,
        validator: (value) =>
            value!.trim().isEmpty ? "Please enter your email!" : null,
        decoration: inputFieldDecorate("Email address", Icons.email));

    Future<void> handleSubmit() async {
      Map data = {
        "email": emailController.text.trim(),
      };

      if (_formKey.currentState!.validate()) {
        final bool verified = await verifyEmail(data);

        if (verified) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Password reset code successfully sent to your email!'),
            backgroundColor: Colors.green,
          ));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CodeVerificationScreen(email: data['email'])));
        }
      }
    }

    // Login Button
    final Widget resetButton = buildButton(context, PRIMARY_BLUE,
        "SEND PASSWORD RESET CODE", btnStyle, handleSubmit, LIGHT_GREY);

    return Scaffold(
        body: Center(
            child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                        child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 120,
                                  height: 180,
                                  child: Image.asset('images/ideas.png'),
                                ),
                                Text("Reset your password".toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: style.copyWith(
                                        fontSize: 20.0, letterSpacing: 3)),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                    "A password reset code will be sent to your email",
                                    textAlign: TextAlign.center,
                                    style: style.copyWith(color: PRIMARY_BLUE)),
                                const SizedBox(height: 50.0),
                                emailField,
                                const SizedBox(
                                  height: 35.0,
                                ),
                                resetButton,
                              ],
                            )))))));
  }
}
