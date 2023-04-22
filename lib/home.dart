import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _senha = '';
  int _comprimentoSenha = 8;

  String gerarSenhaAleatoria(int comprimento) {
    const chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%ˆ&*()";
    final random = Random.secure();
    return List.generate(
        comprimento, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Gerador de Senha'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'images/gerar_logo.png',
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                'Comprimento da Senha: $_comprimentoSenha',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Slider.adaptive(
                thumbColor: Colors.black,
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                value: _comprimentoSenha.toDouble(),
                min: 6,
                max: 20,
                divisions: 14,
                label: _comprimentoSenha.toString(),
                onChanged: (double value) {
                  setState(() {
                    _comprimentoSenha = value.round();
                  });
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Gerar Senha'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _senha = gerarSenhaAleatoria(_comprimentoSenha);
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  Clipboard.setData(ClipboardData(text: _senha));
                  setState(() {
                    Fluttertoast.showToast(
                      msg: "Senha copiada para a área de transferência",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.grey[700],
                      textColor: Colors.white,
                    );
                  });

                },
                child: Text(
                _senha,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),),
              SizedBox(height: 8,),
              if(!_senha.isEmpty)
                Text('Clique na senha para Copia.')

            ],
          ),
        ),
      ),
    );
  }
}
