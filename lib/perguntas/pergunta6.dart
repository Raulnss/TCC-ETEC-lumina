import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/aplicativo/principal.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/save_fliles_temp.dart';
import 'package:lumina/widgets/var_globais.dart';

class pergunta6 extends StatefulWidget {
  const pergunta6({super.key});

  @override
  State<pergunta6> createState() => pergunta6State();
}
class pergunta6State extends State<pergunta6> {
  final CounterStorage_temp storage = CounterStorage_temp();
  final CounterStorage storage_C = CounterStorage();
  String testo = "";
  String opcao = "";
  void Cadastro_nome(String opcao, String id) async {
    http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/geral.php'),
    body: {
      "operacao": "cadastro_duracao_media_mestruacao",
      "opcao": opcao,
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
                  testo = "Ocorreu um erro";
                });
            } else if (data['data'][0] == "sucesso") {
              if (kDebugMode) {
                print(data['data'][0]);
              }
                  if (kDebugMode) {
                    print("Resposta bruta: ${response.body}");
                  }
                setState(() async {
                  await storage_C.writeCounter(id);
                  await storage.writeCounter_temp("");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => principal()),
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
                      "QUAL A DURAÇÃO\n MÉDIA DA SUA\n MENSTRUAÇÃO?",
                      textAlign: TextAlign.center, // Centraliza o texto
                      style: TextStyle(
                        color: const Color.fromARGB(255, 225, 30, 95),
                        fontSize: 40, // Ajuste o tamanho da fonte aqui
                        fontWeight: FontWeight.bold,
                        height: 1.2, // Ajuste o espaçamento entre as linhas
                      ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            opcao = "Menos de 3 dias";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: opcao == "Menos de 3 dias"
                              ? const Color.fromARGB(255, 244, 165, 191)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                        ),
                        child: Text(
                          "Menos de 3 dias",
                          style: TextStyle(
                            color: opcao == "Menos de 3 dias"
                                ? Colors.white
                                : const Color.fromARGB(255, 244, 165, 191),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            opcao = "3 a 5 dias";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: opcao == "3 a 5 dias"
                              ? const Color.fromARGB(255, 244, 165, 191)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                        ),
                        child: Text(
                          "3 a 5 dias",
                          style: TextStyle(
                            color: opcao == "3 a 5 dias"
                                ? Colors.white
                                : const Color.fromARGB(255, 244, 165, 191),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            opcao = "mais de 5 dias";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: opcao == "mais de 5 dias"
                              ? const Color.fromARGB(255, 244, 165, 191)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 87, vertical: 20),
                        ),
                        child: Text(
                          "mais de 5 dias",
                          style: TextStyle(
                            color: opcao == "mais de 5 dias"
                                ? Colors.white
                                : const Color.fromARGB(255, 244, 165, 191),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            opcao = "Não sei";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: opcao == "Não sei"
                              ? const Color.fromARGB(255, 244, 165, 191)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 20),
                        ),
                        child: Text(
                          "Não sei",
                          style: TextStyle(
                            color: opcao == "Não sei"
                                ? Colors.white
                                : const Color.fromARGB(255, 244, 165, 191),
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (opcao != "") {
                          String cd = await storage.readCounter_temp();
                          if (kDebugMode) {
                            print("opção: $opcao, ID: $cd");
                          }
                          Cadastro_nome(opcao, cd);
                        } else {
                          setState(() {
                            testo = "Selecione alguma resposta.";
                          });
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