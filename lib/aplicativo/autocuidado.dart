import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lumina/widgets/botao_selecao.dart';
import 'package:lumina/widgets/dados_dia.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumina/widgets/var_globais.dart';

class autocuidado extends StatefulWidget {
  const autocuidado({super.key});
  @override
  State<autocuidado> createState() => autocuidadoState();
}

class autocuidadoState extends State<autocuidado> {
  final CounterStorage storage = CounterStorage();
  final Map<String, IconData> iconesFluxo = {
    "Leve": Icons.water_drop_outlined,
    "Moderado": FontAwesomeIcons.dropletSlash,
    "Forte": FontAwesomeIcons.droplet,
  };

  DateTime dataAtual = DateTime.now();
  Map<String, DadosDia> dadosPorData = {};
  final TextEditingController _anotacaoController = TextEditingController();
  DadosDia dadosDiaAtual = DadosDia();

  void alterarDia(int dias) {
    setState(() {
      dataAtual = dataAtual.add(Duration(days: dias));
      carregarDadosDoDia();
    });
  }

  void carregarDadosDoDia() {
    String chave = _formatoData(dataAtual);
    dadosPorData.putIfAbsent(chave, () => DadosDia());

    setState(() {
      dadosDiaAtual = dadosPorData[chave]!.clone();
      _anotacaoController.text = dadosDiaAtual.anotacao;
    });
  }

  String _formatoData(DateTime data) {
    return DateFormat('yyyy-MM-dd').format(data);
  }

  void salvarDados(String id) async {
    if (dadosDiaAtual.sintomas.isEmpty &&
        dadosDiaAtual.humores.isEmpty &&
        dadosDiaAtual.fluxo.isEmpty &&
        dadosDiaAtual.anotacao.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha pelo menos um campo antes de salvar.")),
      );
      return;
    }
    String chave = _formatoData(dataAtual);
    dadosPorData[chave] = dadosDiaAtual.clone();
    final url = Uri.parse(apiBaseUrl + "/geral.php");
    try {
      final response = await http.post(
        url,
        body: {
          'operacao': "Autocuidado_salvar",
          'id': id,
          'data': chave,
          'sintomas': jsonEncode(dadosDiaAtual.sintomas),
          'humores': jsonEncode(dadosDiaAtual.humores),
          'fluxo': dadosDiaAtual.fluxo,
          'anotacao': dadosDiaAtual.anotacao,
        },
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Salvo com sucesso no banco de dados!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao salvar no servidor.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro de conexão: $e")),
      );
    }
  }

  void carregarDadosDoServidor(String id) async {
    final url = Uri.parse(apiBaseUrl + "/geral.php");

    try {
      final response = await http.post(
        url,
        body: {
          'operacao': "Autocuidado_carregar",
          'id': id,
        },
      );

      if (response.statusCode == 200) {
        try {
          final resposta = jsonDecode(response.body);
          final Map<String, dynamic> dadosJson = resposta["data"][0];
          dadosPorData.clear();

          dadosJson.forEach((data, valor) {
            List<String> extrairLista(dynamic campo) {
              if (campo is String) {
                try {
                  return List<String>.from(jsonDecode(campo));
                } catch (_) {
                  return [];
                }
              } else if (campo is List) {
                return List<String>.from(campo);
              } else {
                return [];
              }
            }

            dadosPorData[data] = DadosDia(
              humores: extrairLista(valor['humores']),
              sintomas: extrairLista(valor['sintomas']),
              fluxo: valor['fluxo'] ?? "",
              anotacao: valor['anotacao'] ?? "",
            );
          });

          setState(() {});
        } catch (e) {
          print("Erro ao processar dados: $e");
        }
      } else {
        print("Erro na requisição: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao carregar dados: $e");
    }
  }

  void pega_id() async {
    String id = await storage.readCounter();
    carregarDadosDoServidor(id);
  }

  @override
  void initState() {
    super.initState();
    pega_id();
  }

  @override
  Widget build(BuildContext context) {
    final dataFormatada = DateFormat('dd/MMMM/yyyy', 'pt_BR').format(dataAtual);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => alterarDia(-1),
            ),
            Text(dataFormatada, style: TextStyle(color: Colors.black)),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => alterarDia(1),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ---------- TÍTULO: SINTOMAS ----------
            _titulo("SINTOMAS FÍSICOS"),

            /// ---------- GRID ALINHADO DE SINTOMAS ----------
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: NeverScrollableScrollPhysics(),
              children: DadosDia.sintomasDisponiveis.map((s) {
                return BotaoSelecao(
                  texto: s,
                  selecionado: dadosDiaAtual.sintomas.contains(s),
                  onTap: () {
                    setState(() {
                      dadosDiaAtual.toggleSintoma(s);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// ---------- TÍTULO: FLUXO ----------
            _titulo("FLUXO DA MENSTRUAÇÃO"),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: DadosDia.fluxosDisponiveis.map((f) {
                return BotaoSelecao(
                  texto: f,
                  selecionado: dadosDiaAtual.fluxo == f,
                  svgIcon: f == "Moderado" ? "assets/gota_meio_cheia.svg" : null,
                  icone: f != "Moderado" ? iconesFluxo[f] : null,
                  onTap: () {
                    setState(() {
                      dadosDiaAtual.fluxo = f;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// ---------- TÍTULO: HUMOR ----------
            _titulo("HUMOR"),

            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              physics: NeverScrollableScrollPhysics(),
              children: DadosDia.humoresDisponiveis.map((h) {
                return BotaoSelecao(
                  texto: h,
                  selecionado: dadosDiaAtual.humores.contains(h),
                  icone: DadosDia.iconesHumores[h],
                  onTap: () {
                    setState(() {
                      dadosDiaAtual.toggleHumor(h);
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// ---------- TÍTULO: ANOTAÇÕES ----------
            _titulo("ANOTAÇÕES"),

            TextField(
              maxLines: 3,
              controller: _anotacaoController,
              onChanged: (text) {
                dadosDiaAtual.anotacao = text;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite aqui...",
                hintStyle: TextStyle(color: Colors.pink.shade900, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                String id = await storage.readCounter();
                salvarDados(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 238, 236, 179),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text("Salvar",
                  style: TextStyle(color: Colors.pink.shade900, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  /// ---------- WIDGET PARA OS TÍTULOS ----------
  Widget _titulo(String texto) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 238, 236, 179),
          border: Border.all(color: Colors.pink.shade200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          texto,
          style: TextStyle(color: Colors.pink.shade900, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
