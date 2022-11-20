import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Calculator',
      theme: ThemeData(primarySwatch: Colors.red),
      home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 38.0;
  double resultFontSize = 48.0;

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        equationFontSize = 38.0;
        resultFontSize = 48.0;
      } else if (buttonText == "⌫") {
        equationFontSize = 48.0;
        resultFontSize = 38.0;
        equation = equation.substring(0, equation.length - 1);
        if (equation.length == 0) {
          equation = "0";
        }
      } else if (buttonText == "=") {
        equationFontSize = 38.0;
        resultFontSize = 48.0;
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = new Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = "Error";
        }
      } else if (buttonText == "+/-") {
        if (equation != "0") {
          equationFontSize = 48.0;
          resultFontSize = 38.0;
          equation = "-" + equation;
        }
      } else {
        if (!(equation.length > 30)) {
          equationFontSize = 48.0;
          resultFontSize = 38.0;
          if (equation == "0") {
            equation = buttonText;
          } else {
            equation += buttonText;
          }
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    side: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid))),
            padding:
                MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16.0))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Simple Calculator')),
      body: Column(children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text(
            equation,
            style: TextStyle(fontSize: equationFontSize),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text(
            result,
            style: TextStyle(fontSize: resultFontSize),
          ),
        ),
        Expanded(
          child: Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .75,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("C", 1, Colors.redAccent),
                    buildButton("×", 1, Colors.blue),
                    buildButton("÷", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("7", 1, Colors.grey),
                    buildButton("8", 1, Colors.grey),
                    buildButton("9", 1, Colors.grey),
                  ]),
                  TableRow(children: [
                    buildButton("4", 1, Colors.grey),
                    buildButton("5", 1, Colors.grey),
                    buildButton("6", 1, Colors.grey),
                  ]),
                  TableRow(children: [
                    buildButton("1", 1, Colors.grey),
                    buildButton("2", 1, Colors.grey),
                    buildButton("3", 1, Colors.grey),
                  ]),
                  TableRow(children: [
                    buildButton("+/-", 1, Colors.grey),
                    buildButton("0", 1, Colors.grey),
                    buildButton(".", 1, Colors.grey),
                  ])
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("⌫", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("-", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("+", 1, Colors.blue),
                  ]),
                  TableRow(children: [
                    buildButton("=", 2, Colors.redAccent),
                  ]),
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
