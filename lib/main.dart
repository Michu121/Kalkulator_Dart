import 'package:flutter/material.dart';
// Main - Włączenie aplikacji
void main() {
  runApp(const MyApp());
}
final ButtonStyle globalButtonStyle = ElevatedButton.styleFrom(
  padding: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  backgroundColor: Colors.grey.shade800,
  foregroundColor: Colors.white,
  elevation: 2,
  shadowColor: Colors.white,
  );
// Style aplikacji i takie tam
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Material app - materiał aplikacji, czyli tytuł podstawowe parametry
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator',
      // theme- styl domyślny/główny
      theme: ThemeData(
        // Styl dla przycisków
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: globalButtonStyle
        ),


        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
      ),
      home: const MyHomePage(title: 'Kalkulator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = "0";
  String _number1 = "0";
  String _char = '';
  String _number2 = "";
  bool _zeroError = false;

  void _setNumber(String value) {
    setState(() {
      if (_char == "") {
        if (_number1 == "0") {
          _number1 = value;
        } else {
          _number1 += value;
        }
      } else {
        _number2 += value;
      }
      _updateText();
    });
  }

  Future<void> _setChar(String char) async {
    setState(() {
      if (char == "=") {
        if (_number1.isNotEmpty && _number2.isNotEmpty) {
          int number1 = int.parse(_number1);
          int number2 = int.parse(_number2);

          switch (_char) {
            case '+':
              _text = (number1 + number2).toString();
              break;
            case '-':
              _text = (number1 - number2).toString();
              break;
            case '*':
              _text = (number1 * number2).toString();
              break;
            case '/':
              if (number2 == 0) {
                _text = "Can't divide by 0";
                _zeroError = true;
              } else {
                _text = (number1 ~/ number2).toString();
              }
              break;
            default:
              _text = _number1;
          }

          if (!_zeroError) {
            _zeroError = false;
            _number1 = _text;
            _number2 = "";
            _char = "";
          }
        }
      }else if (char == "C") {
        _clear();
      } else {
        if (_number1.isNotEmpty) {
          _char = char;
          _updateText();
        }
      }
    });
    if (_zeroError) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _zeroError = false;
        _number2 = "";
        _updateText();
      });
    }
  }

  void _clear() {
    setState(() {
      _number1 = "0";
      _number2 = "";
      _char = "";
      _text = "0";
    });
  }

  void _updateText({String updatedText = ""}) {
    if (updatedText != "") {
      _text = updatedText;
    } else {
      _text = _number1 + _char + _number2;
    }
  }

  Widget buildButton(String value, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox.expand(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Colors.grey.shade800,
            ),
            onPressed: () =>
            "+-*/=C".contains(value) ? _setChar(value) : _setNumber(value),
            child: Text(value),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Wyświetlacz
                SizedBox(
                  height: constraints.maxHeight * 0.35,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _text,
                      style: const TextStyle(color: Colors.white, fontSize: 48),
                    ),
                  ),
                ),
                // Przyciski
                SizedBox(
                  height: constraints.maxHeight * 0.65,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            buildButton("1"),
                            buildButton("2"),
                            buildButton("3"),
                            buildButton("-", color: Colors.orange),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            buildButton("4"),
                            buildButton("5"),
                            buildButton("6"),
                            buildButton("+", color: Colors.orange),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            buildButton("7"),
                            buildButton("8"),
                            buildButton("9"),
                            buildButton("*", color: Colors.orange),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            buildButton("C", color: Colors.red),
                            buildButton("0"),
                            buildButton("=", color: Colors.green),
                            buildButton("/", color: Colors.orange),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}