import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/acesso/login.dart';
import 'package:lumina/aplicativo/senha.dart';
import 'package:lumina/widgets/app_controler.dart';
import 'package:lumina/widgets/color.dart';
import 'package:lumina/widgets/notification_controller.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/save_file_noti.dart';
import 'package:lumina/widgets/save_file_tema.dart';
import 'package:lumina/widgets/var_globais.dart';
import 'package:provider/provider.dart';

class perfil extends StatefulWidget {
  const perfil({super.key});
  @override
  State<perfil> createState() => _perfilState();
}

class _perfilState extends State<perfil> {
  final CounterStorage storage = CounterStorage();
  final CounterStorage_noti storage_noti = CounterStorage_noti();
  final CounterStorage_tema storage_tema = CounterStorage_tema();

  String nome = "";
  String email = "";
  String id = "";
  bool _notificacoes = false;
  bool _isDarkMode = false;

  // Carrega preferências do tema e notificações
  void _loadPreferences() async {
    String theme = await storage_tema.readCounter();
    String noti = await storage_noti.readCounter();

    setState(() {
      _isDarkMode = theme == "dark";
      _notificacoes = noti == "1";
    });
  }

  // Busca nome e email do usuário
  void Pega_nome(String id) async {
    try {
      final response = await http.post(
        Uri.parse(apiBaseUrl+'/geral.php'),
        body: {"operacao": "Pega_nome_email", "id": id},
        headers: {
          'Accept': 'application/json',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'][0] != "") {
          setState(() {
            nome = data['data'][0]['nm_user'];
            email = data['data'][0]['nm_email'];
          });
        }
      }
    } catch (e) {
      if (kDebugMode) print("Erro ao buscar dados: $e");
    }
  }

  // Inicializa o estado carregando dados
  void pega_id() async {
    id = await storage.readCounter();
    Pega_nome(id);
    _loadPreferences();

    // Notifica o NotificationController sobre o ID do usuário
    Provider.of<NotificationController>(context, listen: false)
        .initializeUser(id);
  }

  Future<void> _updateNotificationPreference(bool value) async {
    await storage_noti.writeCounter(value ? "1" : "0");
    Provider.of<NotificationController>(context, listen: false)
        .updateNotification(value);
  }

  Future<void> _updateThemePreference(bool value) async {
    await storage_tema.writeCounter(value ? "dark" : "light");
    setState(() {
      _isDarkMode = value;
    });
  }

  Future<void> _logout() async {
    await storage.writeCounter("");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => login()),
    );
  }

  @override
  void initState() {
    super.initState();
    pega_id();
  }

  final pinkColor = hexColor("#bc244c");
  final lightPink = const Color(0xFFF2E7E7);

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<appcontroler>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            Text("MEU PERFIL",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: pinkColor)),
            const SizedBox(height: 20),
            _buildInfoRow(nome),
            const SizedBox(height: 10),
            _buildInfoRow(email),
            const SizedBox(height: 10),
            _buildSenhaButton(),
            const SizedBox(height: 20),
            Text("Configurações",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: pinkColor)),
            const SizedBox(height: 10),

            // Tema
            _buildSwitchTile("Modo escuro", _isDarkMode, (value) {
              appController.changeTheme();
              _updateThemePreference(value);
            }),

            // Notificações
            _buildSwitchTile("Permitir notificações", _notificacoes, (value) {
              setState(() {
                _notificacoes = value;
              });
              _updateNotificationPreference(value);
            }),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 225, 177, 193),
                  padding: const EdgeInsets.symmetric(vertical: 15)),
              child: Text("Sair", style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 164, 4, 57))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Container(
      decoration: BoxDecoration(
        color: lightPink,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.pink)),
    );
  }

  Widget _buildSenhaButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Alterar Senha')),
              body: const senha(),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPink,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("senha", style: TextStyle(fontSize: 16, color: Colors.pink)),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}