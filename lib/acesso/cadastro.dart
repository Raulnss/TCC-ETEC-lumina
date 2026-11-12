import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lumina/acesso/login.dart';
import 'package:lumina/perguntas/pergunta1.dart';
import 'package:lumina/widgets/color.dart';
import 'package:lumina/widgets/custon_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/widgets/save_fliles_temp.dart';
import 'package:lumina/widgets/var_globais.dart';

class cadastro extends StatefulWidget {
  const cadastro({super.key});
  @override
  State<cadastro> createState() => cadastroState();
}
class cadastroState extends State<cadastro> {
  final CounterStorage_temp storage = CounterStorage_temp(); 
  String testo = "";
  void cadastro(String email, String pass) async {
  try {
    // Cria o usuário no Firebase
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);

    User? user = userCredential.user;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();

      setState(() {
        testo = "Verifique seu e-mail para continuar o cadastro, verifique a caixa de spam.";
      });

      // Mostra diálogo que verifica automaticamente a cada 3s
      bool? emailVerificado = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              Timer? timer;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (timer == null) {
                  timer = Timer.periodic(const Duration(seconds: 3), (t) async {
                    await user!.reload();
                    user = FirebaseAuth.instance.currentUser;
                    if (user!.emailVerified) {
                      t.cancel();
                      Navigator.of(context).pop(true); // e-mail verificado
                    }
                  });
                }
              });

              return AlertDialog(
                title: const Text("Verifique seu e-mail"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Um e-mail de verificação foi enviado para você, verifique a caixa de spam."),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Aguardando verificação..."),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      try {
                        await user!.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("E-mail de verificação reenviado."),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erro ao reenviar: $e")),
                        );
                      }
                    },
                    child: const Text("Reenviar e-mail"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // usuário cancelou
                    },
                    child: const Text("Cancelar"),
                  ),
                ],
              );
            },
          );
        },
      );

      if (emailVerificado != true) {
        setState(() {
          testo = "Verificação cancelada ou não concluída.";
        });
        return;
      }
    }

    // E-mail verificado com sucesso, segue com cadastro no PHP
    http.Response response = await http.post(
      Uri.parse(apiBaseUrl+'/cadastro.php'),
      body: {
        "email": email,
        "senha": pass,
      },
      headers: {
        'Accept': 'application/json',
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
      },
    );

    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        if (kDebugMode) print(data['data'][0]);

        if (data['data'][0] ==
            "Erro no cadastro, esse email já está em uso por outra conta.") {
          setState(() {
            testo = data['data'][0];
          });
        } else if (data['data'][0] == "Cadastro realizado com sucesso.") {
          await storage.writeCounter_temp(data['data'][1]);
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const pergunta1()),
            );
          }
        } else {
          setState(() {
            testo = data['data'][0];
          });
        }
      } catch (e) {
        if (kDebugMode) print("Erro ao decodificar JSON: $e");
      }
    } else {
      if (kDebugMode) print('Erro na requisição: ${response.statusCode}');
    }
  } on FirebaseAuthException catch (e) {
    String mensagemErro = "Erro desconhecido.";
    if (e.code == 'email-already-in-use') {
      mensagemErro = "Este e-mail já está em uso.";
    } else if (e.code == 'invalid-email') {
      mensagemErro = "E-mail inválido.";
    } else if (e.code == 'weak-password') {
      mensagemErro = "Senha muito fraca. Use pelo menos 6 caracteres.";
    }

    setState(() {
      testo = mensagemErro;
    });
  } catch (e) {
    if (kDebugMode) print("Erro inesperado: $e");
    setState(() {
      testo = "Erro ao criar conta. Tente novamente.";
    });
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
  customTextfiel passtextCon = customTextfiel(
    title: "Confirme sua senha", 
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
                    "CADASTRAR",
                    style: TextStyle(
                        // color: const Color.fromARGB(255, 225, 30, 95),
                        color: hexColor("#bc244c"),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                  emailText.textFormField(),
                  SizedBox(height: 20,),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter localSetState) {
                      return passtext.textFormField(toggle: () {
                        localSetState(() {});
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter localSetState) {
                      return passtextCon.textFormField(toggle: () {
                        localSetState(() {});
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (passtext.value == passtextCon.value) {
                        if (passtext.value.length >= 8) {
                          cadastro(emailText.value, passtext.value);
                        } else {
                          setState(() {
                            testo = "A senha precisa ter ao menos 8 caracteres.";
                          });
                        }
                      } else {
                        setState(() {
                          testo = "As senhas não são compativeis";
                        });
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
                  SizedBox(height: 5),
                  Text(testo),
                  SizedBox(height: 20),
                  Text("Já tem uma conta?",
                  style: TextStyle(
                      color: Colors.pink[200],
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => login()),
                      );
                    },
                    child: Text(
                      "Entre nela!",
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