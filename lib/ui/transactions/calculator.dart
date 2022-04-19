import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:provider/provider.dart';
import 'package:spending_share/ui/helpers/change_notifiers/transaction_change_notifier.dart';
import 'package:spending_share/utils/globals.dart' as globals;
import '../../utils/screen_util_helper.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key, required this.color}) : super(key: key);

  final String color;

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  var userInput = '';
  var answer = '';
  int operatorOpacity = 500;
  int bracketAndDelOpacity = 300;
  int equalOpacity = 800;
  int cOpacity = 500;
  int numberOpacity = 900;

  final List<String> buttons = ['C', '(', ')', '⌫', '7', '8', '9', '÷', '4', '5', '6', 'x', '1', '2', '3', '-', '0', '.', '=', '+'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              userInput,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              answer,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                      answer = '0';
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
                return Consumer<CreateTransactionChangeNotifier>(builder: (_, createTransactionChangeNotifier, __) {
                  return MyButton(
                    buttontapped: () {
                      setState(() {
                        equalPressed(createTransactionChangeNotifier);
                      });
                    },
                    buttonText: buttons[index],
                    color: globals.colors[widget.color]![equalOpacity],
                    textColor: Colors.white,
                  );
                });
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
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed(CreateTransactionChangeNotifier createTransactionChangeNotifier) {
    try {
      String finalUserInput = userInput.replaceAll('x', '*').replaceAll('÷', '/');
      Parser p = Parser();
      Expression exp = p.parse(finalUserInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval < 0) {
        answer = 'value_must_be_greater_than_zero'.tr;
        createTransactionChangeNotifier.setValue(null);
      } else {
        if (eval.floor() == eval) {
          answer = eval.toInt().toString();
        } else {
          answer = eval.toString();
        }
        createTransactionChangeNotifier.setValue(eval);
      }
    } on Exception catch (e) {
      answer = 'format_error'.tr;
      createTransactionChangeNotifier.setValue(null);
    }
  }
}

class MyButton extends StatelessWidget {
  // declaring variables
  final Color? color;
  final Color? textColor;
  final String buttonText;
  final VoidCallback buttontapped;

  //Constructor
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
