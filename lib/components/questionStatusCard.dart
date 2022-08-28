import 'package:flutter/material.dart';
import '../constants.dart';
import '../screens/test_screen/result_answers_screen.dart';
import '../utilities/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class QuestionStatusCard extends StatefulWidget {
  final String title;
  final int data;
  final int total;
  final Color color;
  final List questions;
  final int quizId;

  const QuestionStatusCard({
    Key? key,
    required this.title,
    required this.data,
    required this.total,
    required this.color,
    required this.questions,
    required this.quizId,
  }) : super(key: key);

  @override
  _QuestionStatusCardState createState() => _QuestionStatusCardState();
}

class _QuestionStatusCardState extends State<QuestionStatusCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        fontSize: 16,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : PRIMARY_DARK,
        fontFamily: 'Montserrat');

    Widget generateQuestionsGauge(
        String innerText, int score, int total, Color color) {
      return SizedBox(
        height: 40,
        width: 60,
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(
              minimum: 0,
              maximum: total.toDouble(),
              showLabels: false,
              showTicks: false,
              axisLineStyle: AxisLineStyle(
                  thickness: 0.2,
                  color: color.withOpacity(0.5),
                  thicknessUnit: GaugeSizeUnit.factor,
                  cornerStyle: CornerStyle.bothCurve),
              pointers: <GaugePointer>[
                RangePointer(
                  cornerStyle: CornerStyle.bothCurve,
                  color: color,
                  value: score.toDouble(),
                  width: 0.2,
                  sizeUnit: GaugeSizeUnit.factor,
                  enableAnimation: true,
                )
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    positionFactor: 0.15,
                    angle: 90,
                    widget: SizedBox(
                      width: 80,
                      child: Text(innerText,
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Provider.of<Auth>(context, listen: false)
                                      .darkTheme
                                  ? Colors.white
                                  : PRIMARY_DARK)),
                    ))
              ])
        ]),
      );
    }

    return GestureDetector(
      onTap: () {
        if (widget.questions.isNotEmpty) {
          Navigator.push(
              context,
              PageTransition(
                  child: ResultAnswersScreen(
                    givenAnswers: widget.questions,
                    quizId: widget.quizId,
                  ),
                  type: PageTransitionType.fade));
        }
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(
              top: 12.0, bottom: 10.0, left: 10.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  generateQuestionsGauge(widget.data.toString(), widget.data,
                      widget.total, widget.color),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.title,
                    style: style.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 22,
              )
            ],
          ),
        ),
      ),
    );
  }
}
