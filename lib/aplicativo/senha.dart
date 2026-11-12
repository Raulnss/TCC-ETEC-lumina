import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/widgets/color.dart';
import 'package:lumina/widgets/custon_textfield.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/var_globais.dart';

class senha extends StatefulWidget {
  const senha({super.key});

  @override
  State<senha> createState() => senhaState();
}
class senhaState extends State<senha> {
  final CounterStorage storage = CounterStorage(); 
  String testo = "";
  void atualizar_senha(String pass, String id) async {
    http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/geral.php'),
    body: {
      "operacao": "atualiza_senha",
      "id": id,
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
            if (data['data'][0] != "sucesso") {
                setState(() {
                  testo = "Erro ao atualizar a senha";
                });
            } else if (data['data'][0] == "sucesso") {
                setState(() {
                    testo = "Senha atualizada com sucesso.";
                });
            } else {
              testo = "Ocorreu algum erro. Tente novamente mais tarde.";
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
  customTextfiel passtext = customTextfiel(
    title: "Sua nova senha", 
    placehouter: "Senha", 
    inPass: true
  );
  customTextfiel passtextCon = customTextfiel(
    title: "Confirme sua senha", 
    placehouter: "Senha", 
    inPass: true
  );
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "ALTERAR SENHA",
                    style: TextStyle(
                        color: hexColor("#bc244c"),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter localSetState) {
                      return passtext.textFormField(toggle: () {
                        localSetState(() {});
                      });
                    },
                  ),
                  SizedBox(height: 10,),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter localSetState) {
                      return passtextCon.textFormField(toggle: () {
                        localSetState(() {});
                      });
                    },
                  ),
                  SizedBox(height: 40,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                    ),
                    onPressed: () async {
                        if (passtext.value == passtextCon.value) {
                          if(passtext.value.length >= 8) {
                            String cd = await storage.readCounter();
                            if (kDebugMode) {
                              print("Nome: ${passtext.value}, ID: $cd");
                            }
                            atualizar_senha(passtext.value, cd);
                          } else {
                            setState(() {
                              testo = "A senha precisa ter ao menos 8 caracteres.";
                            });
                          }
                        } else {
                          setState(() {
                            testo = "As senhas não são compativeis.";
                          });
                        }
                      },
                    child: Text(
                      "Confirmar",
                      style: TextStyle(
                        color: hexColor("#bc244c"),
                      ),
                    ),
                  ),
                  Text(testo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}