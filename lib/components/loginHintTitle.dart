import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:prashna_app/constants.dart';
import 'package:prashna_app/screens/profile_screen/profile_screen.dart';
import 'package:prashna_app/utilities/auth.dart';
import 'package:provider/provider.dart';

class LoginHintTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currTheme = Provider.of<Auth>(context, listen: true);

    TextStyle style = TextStyle(
      color: currTheme.darkTheme ? Colors.white : PRIMARY_DARK,
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                child: const ProfileScreen(), type: PageTransitionType.fade));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: PRIMARY_DARK.withOpacity(0.15),
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
                text: " You can only enroll after login!",
              ),
            ],
            style: style.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto'),
          ),
        ),
      ),
    );
  }
}
