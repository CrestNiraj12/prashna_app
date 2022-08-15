import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../components/buttons.dart';
import '../../constants.dart';
import '../../screens/login_screen/validate_login.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:provider/provider.dart';

class ResetPasswordFormScreen extends StatefulWidget {
  ResetPasswordFormScreen({Key? key, required this.email, required this.token})
      : super(key: key);
  final String email, token;
  @override
  _ResetPasswordFormScreenState createState() =>
      _ResetPasswordFormScreenState();
}

class _ResetPasswordFormScreenState extends State<ResetPasswordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final passController = TextEditingController(); // gets password value
  final confirmPassController =
      TextEditingController(); // gets password confirmation value

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
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
        duration: Duration(seconds: 2),
        backgroundColor: bgColor,
      ),
    );
  }

  void changePassword(Map data) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(showLoadingSnackbar("Processing request"));
      await dio().post('/reset-password', data: data);
      snackBar('Password changed successfully!', bgColor: Colors.green);
      Navigator.pushReplacementNamed(context, '/login');
    } on DioError catch (e) {
      snackBar(
          e.response!.data['errors']['password'][0] ??
              e.response!.data['message'],
          bgColor: Colors.red);
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
        fontFamily: 'Montserrat');

    //Decoration for textfields
    InputDecoration inputFieldDecorate(labelText, IconData prefixIcon) {
      return InputDecoration(
          fillColor: Provider.of<Auth>(context, listen: true).darkTheme
              ? PRIMARY_DARK
              : Colors.white,
          filled: true,
          prefixIcon: Icon(prefixIcon, color: PRIMARY_BLUE),
          focusColor: PRIMARY_BLUE,
          border: OutlineInputBorder(),
          labelStyle: style,
          labelText: labelText,
          errorMaxLines: 2);
    }

    // Input field for password
    final Widget passField = TextFormField(
        controller: passController,
        obscureText: true,
        autocorrect: false,
        style: style,
        validator: (value) => !validatePassword(value!)
            ? "Password must have atleast 8 characters with atleast one letter, one number and one special character!"
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

    Future<Null> handleSubmit() async {
      Map data = {
        "email": widget.email,
        "token": widget.token,
        "password": passController.text,
        "password_confirmation": confirmPassController.text
      };

      if (_formKey.currentState!.validate()) changePassword(data);
    }

    // Login Button
    final Widget resetButton = buildButton(context, PRIMARY_BLUE,
        "CHANGE PASSWORD", btnStyle, handleSubmit, LIGHT_GREY);

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
                                Text(
                                    "Please fill up the following fields to reset your password",
                                    textAlign: TextAlign.left,
                                    style: style.copyWith(
                                        color: Provider.of<Auth>(context,
                                                    listen: true)
                                                .darkTheme
                                            ? Colors.white
                                            : PRIMARY_DARK,
                                        fontSize: 16,
                                        fontFamily: 'Montserrat')),
                                const SizedBox(height: 30.0),
                                passField,
                                const SizedBox(
                                  height: 15.0,
                                ),
                                confirmPassField,
                                const SizedBox(
                                  height: 35.0,
                                ),
                                resetButton,
                              ],
                            )))))));
  }
}
