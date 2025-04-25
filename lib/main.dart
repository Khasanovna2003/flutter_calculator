import 'package:flutter/material.dart';

void main() => runApp(MyCalculatorApp());

class MyCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String displayText = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        displayText = '';
      } else if (value == '=') {
        try {
          displayText = _evaluate(displayText);
        } catch (e) {
          displayText = 'Error';
        }
      } else {
        displayText += value;
      }
    });
  }

  String _evaluate(String expression) {
    final tokens = expression.split(RegExp(r'([+-])')).where((e) => e.isNotEmpty).toList();
    double result = double.tryParse(tokens[0]) ?? 0;

    for (int i = 1; i < tokens.length; i += 2) {
      final op = tokens[i];
      final nextNum = double.tryParse(tokens[i + 1]) ?? 0;
      if (op == '+') {
        result += nextNum;
      } else if (op == '-') {
        result -= nextNum;
      }
    }

    return result.toString();
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6), // Teng masofa ham vertikal, ham gorizontal
        child: AspectRatio(
          aspectRatio: 1,
          child: ElevatedButton(
            onPressed: () => buttonPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: ['C', '+', '-', '='].contains(text) ? Colors.red : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              elevation: 2,
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['1', '2', '3', 'C'],
      ['4', '5', '6', '+'],
      ['7', '8', '9', '-'],
      ['', '0', '.', '='],
    ];

    return Scaffold(
      backgroundColor: Color(0xFFB3E5FC), // Light blue background
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100),
            // Ekran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                height: 80,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  displayText,
                  style: TextStyle(fontSize: 32),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: 100),
            // Tugmalar gridi
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, bottom: 100),
                child: Column(
                  children: buttons.map((row) {
                    return Expanded(
                      child: Row(
                        children: row.map((text) {
                          return text.isEmpty
                              ? Expanded(child: SizedBox())
                              : buildButton(text);
                        }).toList(),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
