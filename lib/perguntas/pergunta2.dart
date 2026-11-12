import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/perguntas/pergunta3.dart';
import 'package:lumina/widgets/save_fliles_temp.dart';
import 'package:lumina/widgets/var_globais.dart';

class pergunta2 extends StatefulWidget {
  const pergunta2({super.key});

  @override
  State<pergunta2> createState() => pergunta2State();
}
class pergunta2State extends State<pergunta2> {
  final CounterStorage_temp storage = CounterStorage_temp();
  String testo = "";
  String opcao = "";
  void Cadastro_nome(String opcao, String id) async {
    http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/geral.php'),
    body: {
      "operacao": "cadastro_regularidade_ciclo",
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
                      MaterialPageRoute(builder: (context) => pergunta3()),
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
                      "VOCÊ COSTUMA\n TER CICLOS\n REGULARES?",
                      textAlign: TextAlign.center, // Centraliza o texto
                      style: TextStyle(
                        color: const Color.fromARGB(255, 225, 30, 95),
                        fontSize: 40, // Ajuste o tamanho da fonte aqui
                        fontWeight: FontWeight.bold,
                        height: 1.2, // Ajuste o espaçamento entre as linhas
                      ),
                    ),
                    SizedBox(height: 20),
                    // Botão SIM
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          opcao = "Sim";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: opcao == "Sim" 
                            ? const Color.fromARGB(255, 244, 165, 191) // Rosa quando selecionado
                            : Colors.white, // Branco quando não
                        padding: const EdgeInsets.symmetric(horizontal: 91, vertical: 20),
                      ),
                      child: Text(
                        "Sim",
                        style: TextStyle(
                          color: opcao == "Sim" 
                              ? Colors.white // Texto branco quando selecionado
                              : const Color.fromARGB(255, 244, 165, 191), // Rosa quando não
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Botão NÃO
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          opcao = "Não";
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: opcao == "Não"
                            ? const Color.fromARGB(255, 244, 165, 191)
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 91, vertical: 20),
                      ),
                      child: Text(
                        "Não",
                        style: TextStyle(
                          color: opcao == "Não" ? Colors.white : const Color.fromARGB(255, 244, 165, 191),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Botão NÃO SEI
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
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      ),
                      child: Text(
                        "Não sei",
                        style: TextStyle(
                          color: opcao == "Não sei" ? Colors.white : const Color.fromARGB(255, 244, 165, 191),
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