import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color.fromARGB(255, 232, 225, 225),
        textTheme: const TextTheme(bodyLarge: TextStyle(fontSize: 22)),
        useMaterial3: true,
      ),
      home: const CalculadoraPage(),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  CalculadoraPageState createState() => CalculadoraPageState();
}

class CalculadoraPageState extends State<CalculadoraPage> {
  String _resultado = '';
  String _expressao = '';

  void _pressionarBotao(String texto) {
    setState(() {
      if (texto == 'AC') {
        _expressao = '';
        _resultado = '';
      } else if (texto == 'DEL') {
        if (_expressao.isNotEmpty) {
          _expressao = _expressao.substring(0, _expressao.length - 1);
        }
      } else if (texto == '=') {
        try {
          _resultado = _calcularExpressao(_expressao);
        } catch (e) {
          _resultado = 'Erro';
        }
      } else if (texto == '%') {
        _expressao += '/100';
      } else {
        if (['+', '-', '*', '/', '.'].contains(texto) && _ultimoEhOperador()) {
          return;
        }
        _expressao += texto;
      }
    });
  }

  String _calcularExpressao(String expr) {
    GrammarParser p = GrammarParser();
    Expression exp = p.parse(expr);
    ContextModel cm = ContextModel();
    double result = exp.evaluate(EvaluationType.REAL, cm);

    if (result.isInfinite || result.isNaN) {
      return 'Erro';
    }

    return result.toString();
  }

  bool _ultimoEhOperador() {
    if (_expressao.isEmpty) return false;
    final ult = _expressao[_expressao.length - 1];
    return ['+', '-', '*', '/', '.'].contains(ult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 232, 225, 225),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expressao,
                    style: const TextStyle(fontSize: 28, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _resultado,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(flex: 2, child: _criarTeclado()),
        ],
      ),
    );
  }

  Widget _criarTeclado() {
    final botoes = [
      ['AC', 'DEL', '%', '/'],
      ['7', '8', '9', '*'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];

    return Column(
      children:
          botoes.map((linha) {
            return Expanded(
              child: Row(
                children:
                    linha.map((texto) {
                      return Expanded(
                        child: ElevatedButton(
                          onPressed: () => _pressionarBotao(texto),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child:
                              texto == 'DEL'
                                  ? const Icon(
                                    Icons.backspace_outlined,
                                    size: 28,
                                  )
                                  : Text(
                                    texto,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                        ),
                      );
                    }).toList(),
              ),
            );
          }).toList(),
    );
  }
}
