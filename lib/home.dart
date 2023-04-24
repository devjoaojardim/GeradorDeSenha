import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'listpassword.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class Password {
  final String name;
  final String password;

  Password({required this.name, required this.password});

  static Password fromMap(Map<String, dynamic> map) {
    return Password(
      name: map['name'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }
}

class _HomeState extends State<Home> {
  String _nome = '';
  String _senha = '';
  int _comprimentoSenha = 8;
  TextEditingController _nameController = TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String gerarSenhaAleatoria(int comprimento) {
    const chars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%ˆ&*()";
    final random = Random.secure();
    return List.generate(
        comprimento, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _savePassword(String name, String password) async {
    final passwordList = _prefs.getStringList('passwords') ?? [];
    final passwordObj = Password(name: name, password: password);
    passwordList.add(jsonEncode(passwordObj.toJson()));
    await _prefs.setStringList('passwords', passwordList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Gerador de Senha'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(child: Center(
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
                onTap: () {
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
                ),
              ),
              SizedBox(
                height: 8,
              ),
              if (!_senha.isEmpty) Text('Clique na senha para Copia.'),
              SizedBox(height: 16),
              if (!_senha.isEmpty)
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Text('Salvar senha'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Salvar senha",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _senha,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Nome da senha",
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancelar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _savePassword(_senha, _nameController.text);
                                Navigator.of(context).pop();
                              },
                              child: Text("Salvar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final passwordList = _prefs.getStringList('passwords');
          if (passwordList == null || passwordList.isEmpty) {
            Fluttertoast.showToast(
              msg: "Voce nao tem senha guardada",
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey[700],
              textColor: Colors.white,
            );
          } else {
            // Há senhas salvas, navegue para a lista
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PasswordList()),
            );
          }
        },
        icon: Icon(Icons.lock),
        label: Text('Senhas salvas'),
        backgroundColor: Colors.black,
      ),
    );
  }
}
