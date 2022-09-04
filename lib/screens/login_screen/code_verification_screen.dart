import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import '../../constants.dart';
import '../../screens/login_screen/reset_password.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import '../../utilities/globals.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class CodeVerificationScreen extends StatefulWidget {
  const CodeVerificationScreen({Key? key, required this.email})
      : super(key: key);
  final String email;

  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  // ignore: close_sinks
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
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

  Future<bool> verifyToken(Map data) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(showLoadingSnackbar("Verifying code"));
      await dio().post('/reset-password/verify', data: data);
      return true;
    } on DioError catch (e) {
      snackBar(
          e.response!.data['errors']['password'][0] ??
              e.response!.data['message'],
          bgColor: Colors.red);
      return false;
    }
  }

  void handleSubmit(v) async {
    formKey.currentState!.validate();

    Map data = {"email": widget.email, "token": currentText};

    bool verified = await verifyToken(data);

    // conditions for validating
    if (currentText.length != 6 || !verified) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
      });
    } else {
      setState(
        () {
          hasError = false;
          snackBar("Password reset code verified!", bgColor: Colors.green);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPasswordFormScreen(
                      email: widget.email, token: currentText)));
        },
      );
    }
  }

  Future<bool> resendCode(Map data) async {
    try {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(showLoadingSnackbar("Resend code in progress"));
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
    return Scaffold(
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    height: 180,
                    child: Image.asset('images/ideas.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Password reset code verification',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color:
                              Provider.of<Auth>(context, listen: true).darkTheme
                                  ? Colors.white
                                  : PRIMARY_DARK),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 20),
                    child: RichText(
                      text: TextSpan(
                          text: "Enter the code sent to ",
                          children: [
                            TextSpan(
                                text: widget.email,
                                style: TextStyle(
                                    color:
                                        Provider.of<Auth>(context, listen: true)
                                                .darkTheme
                                            ? Colors.white
                                            : PRIMARY_DARK,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                          style: TextStyle(
                              color: Provider.of<Auth>(context, listen: true)
                                      .darkTheme
                                  ? LIGHT_GREY
                                  : PRIMARY_GREY,
                              fontSize: 15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.scale,
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeColor: hasError ? Colors.red : PRIMARY_BLUE,
                              activeFillColor:
                                  Provider.of<Auth>(context, listen: true)
                                          .darkTheme
                                      ? PRIMARY_DARK
                                      : Colors.white,
                              selectedColor:
                                  hasError ? Colors.redAccent : PRIMARY_BLUE,
                              inactiveColor:
                                  hasError ? Colors.redAccent : LIGHT_GREY,
                              inactiveFillColor: LIGHT_GREY.withAlpha(50),
                              selectedFillColor:
                                  Provider.of<Auth>(context, listen: true)
                                          .darkTheme
                                      ? PRIMARY_DARK
                                      : Colors.white),
                          cursorColor: PRIMARY_BLUE,
                          animationDuration: const Duration(milliseconds: 200),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          onCompleted: handleSubmit,
                          beforeTextPaste: (text) {
                            if (kDebugMode) {
                              print("Allowing to paste $text");
                            }
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                          onChanged: (String value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError ? "Please enter valid code" : "",
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                            color: Provider.of<Auth>(context, listen: true)
                                    .darkTheme
                                ? LIGHT_GREY
                                : PRIMARY_GREY,
                            fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () async {
                            final mess = ScaffoldMessenger.of(context);
                            bool verified =
                                await resendCode({"email": widget.email});

                            if (verified) {
                              mess.removeCurrentSnackBar();
                              mess.showSnackBar(const SnackBar(
                                content: Text(
                                    'Password reset code successfully sent to your email!'),
                                backgroundColor: Colors.green,
                              ));
                            }
                          },
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                                color: PRIMARY_BLUE,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ))
                    ],
                  ),
                ],
              ))),
    );
  }
}
