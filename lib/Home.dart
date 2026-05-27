import 'package:flutter/cupertino.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String pantalla = '0';
  double numero1 = 0;
  String operador = '';
  bool nuevoNumero = false;
  bool resultadoMostrado = false;

  void _presionarBoton(String texto) {
    setState(() {
      if (texto == 'AC') {
        pantalla = '0';
        numero1 = 0;
        operador = '';
        nuevoNumero = false;
        resultadoMostrado = false;
      } else if (texto == '⌫') {
        if (resultadoMostrado) {
          return;
        }

        if (pantalla.length > 1 && pantalla != 'Error') {
          pantalla = pantalla.substring(0, pantalla.length - 1);
        } else {
          pantalla = '0';
        }
      } else if (texto == '+' || texto == '-' || texto == 'x' || texto == '÷') {
        numero1 = double.parse(pantalla);
        operador = texto;
        nuevoNumero = true;
        resultadoMostrado = false;
      } else if (texto == '=') {
        if (operador == '') {
          return;
        }

        double numero2 = double.parse(pantalla);
        double resultado = 0;

        if (operador == '+') {
          resultado = numero1 + numero2;
        } else if (operador == '-') {
          resultado = numero1 - numero2;
        } else if (operador == 'x') {
          resultado = numero1 * numero2;
        } else if (operador == '÷') {
          if (numero2 == 0) {
            pantalla = 'Error';
            operador = '';
            nuevoNumero = true;
            resultadoMostrado = true;
            return;
          } else {
            resultado = numero1 / numero2;
          }
        }

        pantalla = _formatearResultado(resultado);
        operador = '';
        nuevoNumero = true;
        resultadoMostrado = true;
      } else if (texto == '.') {
        if (resultadoMostrado) {
          pantalla = '0.';
          resultadoMostrado = false;
          nuevoNumero = false;
        } else if (!pantalla.contains('.')) {
          pantalla = pantalla + texto;
        }
      } else {
        if (pantalla == '0' ||
            nuevoNumero ||
            pantalla == 'Error' ||
            resultadoMostrado) {
          pantalla = texto;
          nuevoNumero = false;
          resultadoMostrado = false;
        } else {
          pantalla = pantalla + texto;
        }
      }
    });
  }

  String _formatearResultado(double resultado) {
    if (resultado % 1 == 0) {
      return resultado.toInt().toString();
    } else {
      return resultado.toString();
    }
  }

  static Widget _filaBotones(
    List<String> textos,
    Function(String) presionarBoton,
  ) {
    return Row(
      children: textos.map((texto) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: CupertinoButton(
              color: _esoperador(texto)
                  ? CupertinoColors.systemOrange
                  : CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(40),
              onPressed: () {
                presionarBoton(texto);
              },
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 28,
                  color: _esoperador(texto)
                      ? CupertinoColors.white
                      : CupertinoColors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  static bool _esoperador(String texto) {
    return texto == '+' ||
        texto == '-' ||
        texto == 'x' ||
        texto == '÷' ||
        texto == '=';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Calculadora iOS'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Text(
                  pantalla,
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),

            _filaBotones(['AC', '⌫'], _presionarBoton),
            _filaBotones(['7', '8', '9', '÷'], _presionarBoton),
            _filaBotones(['4', '5', '6', 'x'], _presionarBoton),
            _filaBotones(['1', '2', '3', '-'], _presionarBoton),
            _filaBotones(['0', '.', '=', '+'], _presionarBoton),
          ],
        ),
      ),
    );
  }
}
// Variables para controlar el estado de la calculadora