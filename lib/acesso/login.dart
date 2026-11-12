import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/acesso/cadastro.dart';
import 'package:lumina/aplicativo/principal.dart';
import 'package:lumina/push_notification_service.dart';
import 'package:lumina/widgets/color.dart';
import 'package:lumina/widgets/custon_textfield.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/var_globais.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => loginState();
}
class loginState extends State<login> {
  final CounterStorage storage = CounterStorage(); 
  String testo = "";
  void Login(String email, String pass) async {
    http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/login.php'),
    body: {
      "email": email,
      "senha": pass
    },
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
      },
    );
    if (response.statusCode == 200) {
        try {
            var data = jsonDecode(response.body);
            // if (kDebugMode) {
            //   print(data['msg']);
            // }
            if (data['data'][0] == "Usuario ou senha incorretos.") {
                setState(() {
                  testo = data['data'][0];
                });
            } else if (data['data'][0] == "logado") {
              await storage.writeCounter(data['data'][1]['cd_id']);
              String userId = data['data'][1]['cd_id'];
              await PushNotificationService.initialize(userId);
                setState(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => principal()),
                    );
                });
            } else {
              setState(() {
                testo = "Ocorreu algum erro. Tente novamente mais tarde.";
              });
            }
        } catch (e) {
          if (kDebugMode) {
            print("Erro ao decodificar JSON:  $e  ${response.reasonPhrase}");
          }
        }
    } else {
        if (kDebugMode) {
          print('Erro na requisição: ${response.statusCode}');
        }
    }
}
    customTextfiel emailText = customTextfiel(
    title: "Seu email",
    placehouter: "Email"
  );
  customTextfiel passtext = customTextfiel(
    title: "Sua senha", 
    placehouter: "Senha", 
    inPass: true
  );
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
           FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        color: hexColor("#bc244c"),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  emailText.textFormField(),
                  SizedBox(height: 20),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter localSetState) {
                      return passtext.textFormField(toggle: () {
                        localSetState(() {});
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        Login(emailText.value, passtext.value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 244, 165, 191), 
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), 
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text("Confirmar",
                    style: TextStyle(
                      // color: Colors.pink[200],
                      color:  hexColor("#bc244c"),
                    ),
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(testo),
                  SizedBox(height: 20),
                  Text("Ainda não tem uma conta?",
                  style: TextStyle(
                      color: Colors.pink[200],
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => cadastro()),
                        );
                    },
                    child: Text(
                      "Crie uma!",
                      style: TextStyle(
                          color: hexColor("#bc244c"),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}