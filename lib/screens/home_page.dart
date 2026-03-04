import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          double number1 = double.parse(_number1);
          double number2 = double.parse(_number2);

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
            case '%':
              _text = ((number1/100) * number2).toString();
              break;
            case 'M':
              _text = (number1 % number2).toString();
              break;
            case '/':
              if (number2 == 0) {
                _text = "Can't divide by 0";
                _zeroError = true;
              } else {
                _text = (number1 / number2).toString();
              }
              break;
            default:
              _text = _number1;
          }

          if (!_zeroError) {
            _zeroError = false;
            try{

              String splited = _text.split('.').last;
              if (splited.isNotEmpty && splited.endsWith("0")) {
                _text = _text.split('.').first;
              }
            }catch(e){
              _text = _text;
            }
            _number1 = _text;
            _number2 = "";
            _char = "";
          }
        }
      }else if (char == "C") {
        _clear();
      }else if (char == "D"){
        if (_number1.isNotEmpty && _char.isEmpty) {
          _number1 = _number1.substring(0, _number1.length - 1);
          if (_number1.isEmpty) {
            _number1 = "0";
          }
        }else if (_number2.isNotEmpty && _char.isNotEmpty) {
          _number2 = _number2.substring(0, _number2.length - 1);
          if (_number2.isEmpty) {
            _char = "";
          }
        }else if (_number2.isEmpty && _char.isNotEmpty) {
          _char = "";
        }
        _updateText();

      }else if(char == "."){
          if (_number1.isNotEmpty && _char.isEmpty) {
            if (!_number1.contains(".")) {
              _number1 += ".";
            }
          } else if (_number2.isNotEmpty) {
            if (!_number2.contains(".")) {
              _number2 += ".";
            }
          }
          _updateText();
      }
      else {
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
  void _copyToClipBoard() async {
    if (_text.isEmpty || _text == "0") {
      return;
    }
    await Clipboard.setData(ClipboardData(text: _text));
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
            "+-*/=CD%.M".contains(value) ? _setChar(value) : _setNumber(value),
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
                    child: SizedBox.expand(

                      child: FloatingActionButton(onPressed: _copyToClipBoard,
                      backgroundColor: Colors.transparent,
                      child:Text(
                      _text,
                      style: const TextStyle(color: Colors.white, fontSize: 48),
                      ),
                    ),
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
                            buildButton("C", color: Colors.red.shade800),
                            buildButton("D", color: Colors.red.shade200),
                            buildButton("%", color: Colors.orange),
                            buildButton("+", color: Colors.orange),
                          ],
                        ),
                      ),
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
                            buildButton("*", color: Colors.orange),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            buildButton("7"),
                            buildButton("8"),
                            buildButton("9"),
                            buildButton("/", color: Colors.orange),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            buildButton("M", color: Colors.orange),
                            buildButton("0"),
                            buildButton("=", color: Colors.green),
                            buildButton(".", color: Colors.orange),
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