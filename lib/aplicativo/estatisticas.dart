import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/widgets/color.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/var_globais.dart';
import 'package:url_launcher/url_launcher.dart';

class estatisticas extends StatefulWidget {
  const estatisticas({super.key});

  @override
  State<estatisticas> createState() => estatisticasState();
}
// estatisticas_caregamento
class estatisticasState extends State<estatisticas> {
  final CounterStorage storage = CounterStorage();
  String id = "";
  int folicular = -1;
  int duracaoPeriodo = -1;
  int duracaoCiclo = -1;
  int variacaoCiclo = -1;

  void estatisticas_caregamento(String id) async {
  try {
    final response = await http.post(
      Uri.parse(apiBaseUrl+'/geral.php'),
      body: jsonEncode({
        "operacao": "estatisticas_caregamento",
        "id": id,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'User-Agent': 'Mozilla/5.0',
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        var info = data['data'][0];

        if (info != null && info is Map) {
          setState(() {
            folicular = info['folicular'] ?? -1;
            duracaoPeriodo = info['duracao_periodo'] ?? -1;
            duracaoCiclo = info['duracao_ciclo'] ?? -1;
            variacaoCiclo = info['variacao_ciclo'] ?? -1;
          });
        } else {
          if (kDebugMode) print("Resposta inesperada: $info");
        }
      } catch (e) {
        if (kDebugMode) print("Erro ao decodificar JSON: $e");
      }
    } else {
      if (kDebugMode) print("Erro na requisição: ${response.statusCode}");
    }
  } catch (e) {
    if (kDebugMode) print("Erro na requisição: $e");
  }
}


  void pega_id() async {
    id = await storage.readCounter();
    estatisticas_caregamento(id);
  }

  @override
  void initState() {
    super.initState();
    pega_id();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "ESTATÍSTICAS DO CICLO",
                    style: TextStyle(
                      color: hexColor("#bc244c"),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 238, 236, 179),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "FASES DO CICLO",
                      style: TextStyle(
                        color: hexColor("#bc244c"),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Exemplo com link para YouTube
                StatItem(
                  title: "Fase folicular\n",
                  value: "${folicular} Dias",
                  description: "Começa no primeiro dia da menstruação e dura até a ovulação. Nessa fase, os folículos se desenvolvem nos ovários e os níveis de estrogênio aumentam, o que pode trazer mais energia.",
                  youtubeLink: "https://youtu.be/ujqPbVc9zE0?si=imGdIBAL9DecgVlK", // link opcional
                ),
                SizedBox(height: 10),
                StatItem(
                  title: "Duração média do\n período",
                  value: "${duracaoPeriodo} Dias",
                  description: "Duração média do seu período menstrual com base nos ciclos anteriores.",
                  youtubeLink: "https://youtu.be/ujqPbVc9zE0?si=imGdIBAL9DecgVlK", // link opcional
                ),
                SizedBox(height: 10),
                StatItem(
                  title: "Duração média do\n ciclo",
                  value: "${duracaoCiclo} Dias",
                  description: "Tempo médio entre o primeiro dia de uma menstruação e o primeiro dia da próxima.",
                  youtubeLink: "https://youtu.be/ujqPbVc9zE0?si=imGdIBAL9DecgVlK", // link opcional
                ),
                SizedBox(height: 10),
                StatItem(
                  title: "Variação do ciclo\n",
                  value: "${variacaoCiclo} Dias",
                  description: "Variação registrada entre os diferentes ciclos, indicando regularidade.",
                  youtubeLink: "https://youtu.be/ujqPbVc9zE0?si=imGdIBAL9DecgVlK", // link opcional
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatItem extends StatefulWidget {
  final String title;
  final String value;
  final String description;
  final String? youtubeLink; // novo parâmetro opcional

  const StatItem({
    required this.title,
    required this.value,
    required this.description,
    this.youtubeLink,
    super.key,
  });

  @override
  _StatItemState createState() => _StatItemState();
}

class _StatItemState extends State<StatItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  // Função para abrir link do YouTube
  void abrirVideoYoutube(String link) async {
    final url = Uri.parse(link);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o link.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = hexColor("#bc244c");
    final backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final borderColor = textColor;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(
          color: borderColor,
          width: 1,
        ),
        elevation: 2,
      ),
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: textColor,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Expanded(
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            if (_expanded) ...[
              SizedBox(height: 12),
              Divider(
                color: textColor.withOpacity(0.5),
                thickness: 1,
              ),
              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  if (widget.youtubeLink != null) {
                    abrirVideoYoutube(widget.youtubeLink!);
                  }
                },
                child: Text(
                  widget.description,
                  style: TextStyle(
                    color: widget.youtubeLink != null
                        ? Colors.blueAccent
                        : textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    decoration: widget.youtubeLink != null
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}