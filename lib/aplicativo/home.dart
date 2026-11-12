import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lumina/aplicativo/principal.dart';
import 'package:lumina/widgets/color.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/var_globais.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => homeState();
}

class homeState extends State<home> {
  final CounterStorage storage = CounterStorage();
  late Map<String, String> dicaAtual;
  String nome = "";
  String id = "";
  int diasRestantes = 0;
  int diaDoCiclo = 0;
  String ultimaMenstruacao = "";
  String status = "";
  String fase = "";
  int duracaoCiclo = 0;
  final List<Map<String, String>> dicas = [
  {
    'titulo': 'Mantenha-se hidratada',
    'descricao': 'Isso ajuda a reduzir os sintomas nessa fase',
  },
  {
    'titulo': 'Pratique exercícios leves',
    'descricao': 'Caminhadas ou alongamentos ajudam a aliviar as cólicas',
  },
  {
    'titulo': 'Alimente-se bem',
    'descricao': 'Evite alimentos gordurosos e prefira frutas e vegetais',
  },
  {
    'titulo': 'Use compressa morna',
    'descricao': 'Ajuda a aliviar dores abdominais',
  },
  {
    'titulo': 'Descanse o suficiente',
    'descricao': 'Dormir bem melhora o humor e reduz o estresse',
  },
];

  void Pega_nome(String id) async {
    http.Response response = await http.post(
      Uri.parse('http://minhaapiemphp.elementfx.com/geral.php'),
      body: {"operacao": "Pega_nome", "id": id},
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'Mozilla/5.0'
      },
    );

    if (response.statusCode == 200) {
      try {
        var data = jsonDecode(response.body);
        if (data['data'][0] != "") {
          setState(() {
            nome = data['data'][0];
          });
        }
      } catch (e) {
        if (kDebugMode) print("Erro ao decodificar JSON: $e");
      }
    }
  }
  void dias_para_proxima_menstruacao(String id) async {
  http.Response response = await http.post(
    Uri.parse(apiBaseUrl+'/geral.php'),
    body: {"operacao": "dias_para_proxima_menstruacao", "id": id},
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'Mozilla/5.0'
    },
  );

  if (response.statusCode == 200) {
    try {
      var data = jsonDecode(response.body);

      // data['data'] é uma lista, pegamos o primeiro item que é o objeto retornado
      var info = data['data'][0];

      if (info != null && info is Map) {
        setState(() {
          ultimaMenstruacao = info['ultima_menstruacao'] ?? 'N/A';
          diasRestantes = info['dias_restantes'] ?? 1;
          diaDoCiclo = info['dia_do_ciclo'] ?? 1;
          diaDoCiclo = diaDoCiclo - 1;
          status = info['status'] ?? 'desconhecido';
          duracaoCiclo = info['duracao_ciclo'] ?? 1;
        });
        pegarFaseCiclo(diaDoCiclo,duracaoCiclo);
      } else {
        if (kDebugMode) print("Resposta inesperada: $info");
      }
    } catch (e) {
      if (kDebugMode) print("Erro ao decodificar JSON: $e");
    }
  } else {
    if (kDebugMode) print("Erro na requisição: ${response.statusCode}");
  }
}
void pegarFaseCiclo(int dia, int dur) async {
    try {
      if (dia != 0) {
        setState(() {
          fase = determinarFaseDinamica(dia,dur);
        });
      } else {
        if (kDebugMode) print("Resposta inesperada: $dia");
      }
    } catch (e) {
      if (kDebugMode) print("Erro ao decodificar JSON: $e");
    }
}
String determinarFaseDinamica(int dia, int duracaoCiclo) {
  int ovulacao = (duracaoCiclo / 2).round();
  if (dia >= 1 && dia <= 5) return "Menstruação";
  else if (dia > 5 && dia < ovulacao - 1) return "Fase Folicular";
  else if (dia >= ovulacao - 1 && dia <= ovulacao + 1) return "Ovulação";
  else if (dia > ovulacao + 1 && dia <= duracaoCiclo) return "Fase Lútea";
  else return "Fora do ciclo esperado";
}
  void pega_id() async {
    id = await storage.readCounter();
    Pega_nome(id);
    dias_para_proxima_menstruacao(id);
  }

  @override
  void initState() {
    super.initState();
    pega_id();
    dicaAtual = dicas[Random().nextInt(dicas.length)];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color pinkPrimary = hexColor("#bc244c");
    final Color background = isDark ? Colors.black : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color lightPink = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFFF1F4);
    final Color arcBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFFC5D0);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Fundo com gradiente circular no topo
          Positioned(
            top: -120,
            left: -60,
            right: -60,
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [lightPink, background]
                      : [Color(0xFFFFC5D0), Color(0xFFFFE6EC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                ),
                boxShadow: [
                  BoxShadow(
                    color: pinkPrimary.withOpacity(0.4),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'OLÁ ${nome.isEmpty ? "usuária" : nome}!',
                    style: TextStyle(
                      fontSize: 22,
                      color: pinkPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'SUA MENSTRUAÇÃO DEVE CHEGAR EM:',
                    style: TextStyle(
                      fontSize: 16,
                      color: pinkPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [cardBg, lightPink]
                            : [Colors.white, const Color(0xFFFFF1F4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: pinkPrimary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: pinkPrimary.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '${diasRestantes} Dias',
                      style: TextStyle(
                        fontSize: 18,
                        color: pinkPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // DICA
                  Text(
                    'DICA',
                    style: TextStyle(
                      fontSize: 18,
                      color: pinkPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [cardBg, lightPink]
                            : [Color(0xFFFFF1F4), Color(0xFFFFE6EC)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: pinkPrimary.withOpacity(0.4)),
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dicaAtual['titulo']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: pinkPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dicaAtual['descricao']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: pinkPrimary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Estágio Corporal
                  Text(
                    'ESTÁGIO CORPORAL',
                    style: TextStyle(
                      fontSize: 18,
                      color: pinkPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [lightPink, cardBg]
                            : [Color(0xFFFFC5D0), Color(0xFFFFE6EC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: pinkPrimary.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(1.8),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'HOJE: Dia ${diaDoCiclo} do ciclo',
                            style: TextStyle(
                              fontSize: 16,
                              color: pinkPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Você está na $fase',
                            style: TextStyle(
                              fontSize: 16,
                              color: pinkPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Confira as fases do ciclo em Estatísticas',
                            style: TextStyle(
                              fontSize: 14,
                              color: pinkPrimary.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // REGISTRO DIÁRIO
                  Text(
                    'REGISTO DIÁRIO',
                    style: TextStyle(
                      fontSize: 18,
                      color: pinkPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final principalState = context.findAncestorStateOfType<PrincipalState>();
                        principalState?.selectPage(0);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [lightPink, cardBg]
                                : [Color(0xFFFFC5D0), Color(0xFFFFE6EC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: pinkPrimary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: pinkPrimary.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'COMO ESTÁ SE SENTINDO?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: pinkPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}