import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class PasswordList extends StatefulWidget {
  const PasswordList({Key? key}) : super(key: key);

  @override
  State<PasswordList> createState() => _PasswordListState();
}

class _PasswordListState extends State<PasswordList> {
  late SharedPreferences _prefs;
  List<Password> _passwords = [];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _passwords = _prefs.getStringList('passwords')?.map((passwordJson) {
            final passwordObj = Password.fromMap(jsonDecode(passwordJson));
            return passwordObj;
          }).toList() ??
          [];
      print(_passwords);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Senhas salvas'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _passwords.length,
          itemBuilder: (context, index) {
            final password = _passwords[index];
            final name = password.name;
            final pass = password.password;
            return GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: name));
                setState(() {
                  Fluttertoast.showToast(
                    msg: "Senha copiada para a área de transferência: $name",
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey[700],
                    textColor: Colors.white,
                  );
                });
              },
              child: PasswordItem(name: pass, password: name),
            );
          },
        ),
      ),
    );
  }
}

class PasswordItem extends StatefulWidget {
  final String name;
  final String password;

  const PasswordItem({Key? key, required this.name, required this.password})
      : super(key: key);

  @override
  State<PasswordItem> createState() => _PasswordItemState();
}

class _PasswordItemState extends State<PasswordItem> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${widget.name}:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _isPasswordVisible ? widget.password : '*******',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ],
    );
  }
}
