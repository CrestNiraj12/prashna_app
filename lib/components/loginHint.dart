import 'package:flutter/material.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class LoginHint extends StatelessWidget {
  const LoginHint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);

    TextStyle style = TextStyle(
      color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.blue.withOpacity(0.2),
      ),
      width: MediaQuery.of(context).size.width,
      child: RichText(
        text: TextSpan(
          children: const [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(
                Icons.lightbulb,
                size: 13,
                color: Colors.yellow,
              ),
            ),
            TextSpan(
              text: " Please login to save your progress!",
            ),
          ],
          style: style.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: PRIMARY_BLUE,
              fontFamily: 'Roboto'),
        ),
      ),
    );
  }
}
