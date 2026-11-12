import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/perguntas/pergunta5.dart';
import 'package:lumina/widgets/save_fliles_temp.dart';
import 'package:lumina/widgets/var_globais.dart';

class pergunta4 extends StatefulWidget {
  const pergunta4({super.key});

  @override
  State<pergunta4> createState() => pergunta4State();
}
class pergunta4State extends State<pergunta4> {
  final CounterStorage_temp storage = CounterStorage_temp();
  String testo = "";
  String opcao = "";
  void Cadastro_nome(String opcao, String id) async {
    http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/geral.php'),
    body: {
      "operacao": "cadastro_nivel_energia_ciclo",
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
                setState(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => pergunta5()),
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
                      "COMO COSTUMA\n SER SEU NÍVEL DE\n ENERGIA DURANTE\n O CICLO?",
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
                          opcao = "Alta, não sinto nenhum tipo de cansaço";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: opcao == "Alta, não sinto nenhum tipo de cansaço"
                            ? const Color.fromARGB(255, 244, 165, 191)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 124, vertical: 20),
                      ),
                      child: Text(
                        "Alta, não sinto nenhum tipo de cansaço",
                        style: TextStyle(
                          color: opcao == "Alta, não sinto nenhum tipo de cansaço"
                              ? Colors.white
                              : const Color.fromARGB(255, 244, 165, 191),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          opcao =
                              "Média, até sinto um cansaço, mas nada que interfira no meu dia";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: opcao ==
                                "Média, até sinto um cansaço, mas nada que interfira no meu dia"
                            ? const Color.fromARGB(255, 244, 165, 191)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      ),
                      child: Text(
                        "Média, até sinto um cansaço, mas nada que interfira no meu dia!",
                        style: TextStyle(
                          color: opcao ==
                                  "Média, até sinto um cansaço, mas nada que interfira no meu dia"
                              ? Colors.white
                              : const Color.fromARGB(255, 244, 165, 191),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          opcao = "Baixa, me sinto acabada, sempre estou esgotada";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: opcao ==
                                "Baixa, me sinto acabada, sempre estou esgotada"
                            ? const Color.fromARGB(255, 244, 165, 191)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 93, vertical: 20),
                      ),
                      child: Text(
                        "Baixa, me sinto acabada, sempre estou esgotada!",
                        style: TextStyle(
                          color: opcao ==
                                  "Baixa, me sinto acabada, sempre estou esgotada"
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