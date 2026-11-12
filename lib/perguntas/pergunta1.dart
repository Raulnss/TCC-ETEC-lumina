import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/perguntas/pergunta2.dart';
import 'package:lumina/widgets/custon_textfield.dart';
import 'package:lumina/widgets/save_fliles_temp.dart';
import 'package:lumina/widgets/var_globais.dart';  

class pergunta1 extends StatefulWidget {
  const pergunta1({super.key});

  @override
  State<pergunta1> createState() => pergunta1State();
}

class pergunta1State extends State<pergunta1> {
  final CounterStorage_temp storage = CounterStorage_temp(); 
  String testo = "";
  void Cadastro_nome(String nome, String id) async {
    http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/geral.php'),
    body: {
      "operacao": "cadastra_nome",
      "nome": nome,
      "id": id
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
                  if (kDebugMode) {
                    print(data['data'][0]);
                  }
                  if (kDebugMode) {
                    print("Resposta bruta: ${response.body}");
                  }
                  testo = "Ocorreu um erro ao registrar o seu nome.";
                });
            } else if (data['data'][0] == "sucesso") {
              if (kDebugMode) {
                print(data['data'][0]);
              }
                  if (kDebugMode) {
                    print("Resposta bruta: ${response.body}");
                  }
                setState(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => pergunta2()),
                    );
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
  customTextfiel nomeText = customTextfiel(
    title: "Seu nome",
    placehouter: "Inserir nome",
  );
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 244, 165, 191), // Cor superior
              Color.fromARGB(255, 255, 204, 224), // Cor inferior
            ],
          ),
        ),
        child: GestureDetector(
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
                      "COMO PODEMOS\n TE CHAMAR?",
                      textAlign: TextAlign.center, // Centraliza o texto
                      style: TextStyle(
                        color: const Color.fromARGB(255, 225, 30, 95),
                        fontSize: 40, // Ajuste o tamanho da fonte aqui
                        fontWeight: FontWeight.bold,
                        height: 1.2, // Ajuste o espaçamento entre as linhas
                      ),
                    ),
                    SizedBox(height: 20),
                    nomeText.textFormField(),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (nomeText.value != "") {
                          String cd = await storage.readCounter_temp();
                          if (kDebugMode) {
                            print("Nome: ${nomeText.value}, ID: $cd");
                          }
                          Cadastro_nome(nomeText.value, cd);
                        } else {
                          testo = "Incira o nome.";
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 244, 165, 191),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text(
                        "Continuar",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 244, 70, 128),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(testo),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
