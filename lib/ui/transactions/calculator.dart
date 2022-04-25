import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;

import '../../utils/screen_util_helper.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.color, required this.onEqualPressed}) : super(key: key);

  final String color;
  final Function(double) onEqualPressed;

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  int operatorOpacity = 500;
  int bracketAndDelOpacity = 300;
  int equalOpacity = 800;
  int cOpacity = 500;
  int numberOpacity = 900;

  final List<String> buttons = ['C', '(', ')', '⌫', '7', '8', '9', '÷', '4', '5', '6', 'x', '1', '2', '3', '-', '0', '.', '=', '+'];

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
      return Column(
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                userInput,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            )
          ]),
          GridView.builder(
              shrinkWrap: true,
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: h(15),
                mainAxisSpacing: h(5),
                crossAxisCount: 4,
                mainAxisExtent: h(35),
              ),
              itemBuilder: (BuildContext context, int index) {
                // Clear Button
                if (index == 0) {
                  return MyButton(
                    buttontapped: () {
                      setState(() {
                        userInput = '';
                      });
                    },
                    buttonText: buttons[index],
                    color: globals.colors[widget.color]![cOpacity],
                    textColor: Colors.white,
                  );
                }

                // +/- button
                else if (index == 1) {
                  return MyButton(
                    buttonText: buttons[index],
                    color: globals.colors[widget.color]![bracketAndDelOpacity],
                    textColor: Colors.white,
                    buttontapped: () {
                      setState(() {
                        userInput += buttons[index];
                      });
                    },
                  );
                }
                // % Button
                else if (index == 2) {
                  return MyButton(
                    buttonText: buttons[index],
                    color: globals.colors[widget.color]![bracketAndDelOpacity],
                    textColor: Colors.white,
                    buttontapped: () {
                      setState(() {
                        userInput += buttons[index];
                      });
                    },
                  );
                }
                // Delete Button
                else if (index == 3) {
                  return MyButton(
                    buttontapped: () {
                      setState(() {
                        userInput = userInput.substring(0, userInput.length - 1);
                      });
                    },
                    buttonText: buttons[index],
                    color: globals.colors[widget.color]![bracketAndDelOpacity],
                    textColor: Colors.white,
                  );
                }
                // Equal_to Button
                else if (index == 18) {
                  return MyButton(
                    buttontapped: () {
                      setState(() {
                        if (userInput == '') {
                          return;
                        }
                        try {
                          String finalUserInput = userInput.replaceAll('x', '*').replaceAll('÷', '/');
                          Parser p = Parser();
                          Expression exp = p.parse(finalUserInput);
                          ContextModel cm = ContextModel();
                          double eval = exp.evaluate(EvaluationType.REAL, cm);
                          if (eval < 0) {
                            userInput = 'value_must_be_greater_than_zero'.tr;
                          } else {
                            widget.onEqualPressed(eval);
                            userInput = '';
                          }
                        } on Exception {
                          userInput = 'format_error'.tr;
                        }
                      });
                    },
                    buttonText: buttons[index],
                    color: globals.colors[widget.color]![equalOpacity],
                    textColor: Colors.white,
                  );
                }

                //  other buttons
                else {
                  return MyButton(
                    buttontapped: () {
                      setState(() {
                        userInput += buttons[index];
                      });
                    },
                    buttonText: buttons[index],
                    color: isOperator(buttons[index]) ? globals.colors[widget.color]![operatorOpacity] : Colors.white,
                    textColor: isOperator(buttons[index]) ? Colors.white : globals.colors[widget.color]![numberOpacity],
                  );
                }
              }),
        ],
      );
    });
  }

  bool isOperator(String x) {
    if (x == '÷' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  setUserInput(String s) {
    userInput = s;
  }
}

class MyButton extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final String buttonText;
  final VoidCallback buttontapped;

  const MyButton({
    Key? key,
    this.color,
    this.textColor,
    required this.buttonText,
    required this.buttontapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.all(0.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
