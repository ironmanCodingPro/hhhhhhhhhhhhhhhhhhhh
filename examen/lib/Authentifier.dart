import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Accueil.dart';

class Authentifier extends StatefulWidget {
  const Authentifier({Key? key}) : super(key: key);

  @override
  _AuthentifierState createState() => _AuthentifierState();
}

class _AuthentifierState extends State<Authentifier> {
  late String? code;

  final String baseUrl = "10.0.2.2:9090";

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S'authentifier"),
        centerTitle: true,
      ),
      body: Form(
          key: _keyForm,
          child: Column(children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/images/logo.png")),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Code d'inscription"),
                onSaved: (String? value) {
                  code = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Ce champ est requis";
                  } else if (value.length != 3) {
                    return "Le code doit etrec compose de trois chiffre";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      setState(() {
                        _keyForm.currentState!.reset();
                      });
                    },
                    child: const Text(
                      "Reinitialiser",
                      style: TextStyle(color: Colors.white),
                    )),
                const SizedBox(
                  width: 20,
                ),
                TextButton(
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();
                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=utf-8"
                      };
                      Map<String, dynamic> body = {
                        "code": code!,
                      };
                      http
                          .post(Uri.http(baseUrl, "/api/users/login"),
                              headers: headers, body: json.encode(body))
                          .then((response) async {
                        if (response.statusCode == 200) {
                          Map<String, dynamic> userData =
                              json.decode(response.body);

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("code", userData["_id"]);

                          Navigator.pushReplacementNamed(context, Acceuil.path);
                        } else if (response.statusCode == 401) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Erreur"),
                                  content: Text(
                                      "Le code d'isncription est invalide"),
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text("Informations"),
                                  content: Text("Erreur"),
                                );
                              });
                        }
                      });
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                )
              ],
            )
          ])),
    );
  }
}
