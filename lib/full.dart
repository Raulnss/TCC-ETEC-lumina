import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:lumina/aplicativo/principal.dart';
import 'package:lumina/bem_vindos/splash.dart';
import 'package:lumina/bem_vindos/bem_vindos1.dart';
import 'package:lumina/push_notification_service.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/save_fliles_temp.dart';
import 'package:lumina/perguntas/pergunta1.dart';
import 'package:lumina/widgets/var_globais.dart';

class full extends StatefulWidget {
  const full({super.key});
  @override
  State<full> createState() => fullState();
}
class fullState extends State<full> {
  final CounterStorage storage = CounterStorage();
  final CounterStorage_temp storageTemp = CounterStorage_temp();
  late Future<List<String>> _future;
  @override
  void initState() {
    super.initState();
    _future = _loadAllData();
  }
  Future<bool> _checkApiConnection() async {
    try {
      final response = await http.get(Uri.parse(apiBaseUrl+"/ping.php")).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return body["status"] == "ok";
      }
    } catch (_) {}
    return false;
  }
  Future<List<String>> _loadAllData() async {
    bool isConnected = await _checkApiConnection();
    if (!isConnected) {
      await _showNoConnectionDialog(); // Exibe o popup aqui
      throw Exception("Sem conexão"); // Impede o FutureBuilder de seguir
    }
    String id = await storage.readCounter();
    String tempId = await storageTemp.readCounter_temp();
    return [id, tempId];
  }
  Future<void> _showNoConnectionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Usuário não pode sair tocando fora
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sem conexão com a internet", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Por favor, verifique sua conexão com a internet e tente novamente."),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Future.delayed(Duration(milliseconds: 300), () {
                        // Fecha o app (Android)
                        // import 'dart:io' show exit;
                        exit(0);
                      });
                    },
                    icon: Icon(Icons.close),
                    label: Text('Sair'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _future = _loadAllData();
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return splash();
        } else if (snapshot.hasError) {
          return Container(color: Colors.black); // Tela "vazia" de fundo
        } else {
          String id = snapshot.data?[0] ?? "";
          String tempId = snapshot.data?[1] ?? "";
          if (id.isNotEmpty) {
            // Inicializa notificações push
            PushNotificationService.initialize(id); // Chama aqui
          }
          if (tempId.isNotEmpty) {
            return pergunta1();
          } else if (id.isEmpty) {
            return bemvindos1();
          } else {
            return principal();
          }
        }
      },
    );
  }
}