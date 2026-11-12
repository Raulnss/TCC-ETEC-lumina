import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lumina/widgets/save_file.dart';
import 'package:lumina/widgets/var_globais.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class calendario extends StatefulWidget {
  const calendario({Key? key}) : super(key: key);

  @override
  State<calendario> createState() => calendarioState();
}
class calendarioState extends State<calendario> {
  int? ani;
  final CounterStorage storage = CounterStorage();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  Set<DateTime> _selectedDays = {};
  Set<DateTime> _predictedDays = {};
  int duracaoCiclo = 28;
  int duracaoPeriodo = 5;
  final Color _primaryColor = const Color(0xFFB3446C);
  final Color _secondaryColor = const Color(0xFFF2E7E9);
  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  Future<void> _fetchDatesFromApi(String id) async {
    try {
      final response = await http.post(
        Uri.parse(apiBaseUrl+'/geral.php'),
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
        body: {
          "operacao": "Calendario_carregar_dados",
          "id": id,
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('JSON recebido (calendário): ${response.body}');
        // Assumindo que data['data'] é algo como [["2025-10-10", "2025-11-12", ...]]
        List<String> dateStrings = (data['data'] as List)
            .expand((item) => List<String>.from(item))
            .toList();

        setState(() {
          _selectedDays = dateStrings
              .map((ds) => DateTime.parse(ds))
              .map((d) => normalizeDate(d))
              .toSet();
        });
      } else {
        print('Erro na requisição calendário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao pegar dados do JSON calendário: $e');
    }
  }
  Future<void> _salvarDataNoBanco(String data, String id) async {
    try {
      final response = await http.post(
        Uri.parse(apiBaseUrl+'/geral.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "operacao": "Calendario_salvar_dia",
          "cd_user": id,
          "dt_dias_mestruacao": data,
        }),
      );
      if (response.statusCode != 200) {
        print('Erro ao salvar data: ${response.body}');
      }
    } catch (e) {
      print('Erro no salvarDataNoBanco: $e');
    }
  }
  Future<void> _removerDataDoBanco(String data, String id) async {
    try {
      final response = await http.post(
        Uri.parse(apiBaseUrl+'/geral.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "operacao": "Calendario_deletar_dia",
          "cd_user": id,
          "dt_dias_mestruacao": data,
        }),
      );
      if (response.statusCode != 200) {
        print('Erro ao remover data: ${response.body}');
      }
    } catch (e) {
      print('Erro no removerDataDoBanco: $e');
    }
  }
  Future<void> _fetchAnoMaximo() async {
    try {
      final response = await http.post(
        Uri.parse(apiBaseUrl+'/geral.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "operacao": "Calendario_pegar_ano",
        }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var anoStr = data['data'][0];
        setState(() {
          ani = int.tryParse(anoStr);
        });
      } else {
        print("Erro ao pegar ano: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro no _fetchAnoMaximo: $e");
    }
  }
  Future<void> preverProximaMenstruacao(String id) async {
    try {
      final response = await http.post(
        Uri.parse(apiBaseUrl+'/geral.php'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'Mozilla/5.0',
        },
        body: {
          "operacao": "Calendario_prever_dias",
          "id": id,
        },
      );
      if (response.statusCode == 200) {
        var statsData = jsonDecode(response.body);
        if (kDebugMode) {
          print('JSON recebido (estatísticas): ${response.body}');
        }
        var info = statsData['data'][0];
        // Se as chaves existirem
        duracaoCiclo = info['duracao_ciclo'] ?? duracaoCiclo;
        // Se você também retornar 'duracao_periodo' no PHP, use:
        duracaoPeriodo = info['duracao_periodo'] ?? duracaoPeriodo;
        if (kDebugMode) {
          print("Ciclo: $duracaoCiclo, Período: $duracaoPeriodo");
        }
        if (_selectedDays.isNotEmpty) {
          DateTime ultimaData = _selectedDays.reduce((a, b) => a.isAfter(b) ? a : b);
          DateTime proximaMenstruacao = ultimaData.add(Duration(days: duracaoCiclo));
          Set<DateTime> diasPrevistos = {};
          for (int i = 0; i < duracaoPeriodo; i++) {
            diasPrevistos.add(normalizeDate(proximaMenstruacao.add(Duration(days: i))));
          }
          setState(() {
            _predictedDays = diasPrevistos;
          });
        } else {
          print("Nenhuma data registrada: impossível prever.");
        }
      } else {
        print('Erro na requisição estatísticas: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro ao prever próxima menstruação: $e");
    }
  }
  Future<void> pegarDadosCompletos() async {
    String id = await storage.readCounter();
    await _fetchDatesFromApi(id);
    await preverProximaMenstruacao(id);
  }
  @override
  void initState() {
    super.initState();
    _fetchAnoMaximo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pegarDadosCompletos();
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text('Calendário de Menstruação'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Color(0xFF2C2C2C), Color(0xFF1A1A1A)]
                : [_secondaryColor.withOpacity(0.8), _secondaryColor.withOpacity(0.3)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  brightness: isDarkMode ? Brightness.dark : Brightness.light,
                  colorScheme: isDarkMode
                      ? ColorScheme.dark(
                          primary: _primaryColor, secondary: _secondaryColor)
                      : ColorScheme.light(
                          primary: _primaryColor, secondary: _secondaryColor),
                ),
                child: ani == null
                    ? const Center(child: CircularProgressIndicator())
                    : TableCalendar<dynamic>(
                        locale: 'pt_BR',
                        firstDay: DateTime(2025, 1, 1),
                        lastDay: DateTime(ani!, 12, 31),
                        focusedDay: _focusedDay,
                        calendarFormat: _calendarFormat,
                        selectedDayPredicate: (day) {
                          return _selectedDays.contains(normalizeDate(day));
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                        onDaySelected: (selectedDay, focusedDay) async {
                          final normalizedDay = normalizeDate(selectedDay);
                          setState(() {
                            _focusedDay = focusedDay;
                          });

                          final formattedDate =
                              "${normalizedDay.year}-${normalizedDay.month.toString().padLeft(2, '0')}-${normalizedDay.day.toString().padLeft(2, '0')}";

                          String id = await storage.readCounter();
                          if (_selectedDays.contains(normalizedDay)) {
                            setState(() {
                              _selectedDays.remove(normalizedDay);
                            });
                            await _removerDataDoBanco(formattedDate, id);
                          } else {
                            setState(() {
                              _selectedDays.add(normalizedDay);
                            });
                            await _salvarDataNoBanco(formattedDate, id);
                          }

                          await preverProximaMenstruacao(id);
                        },
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: _primaryColor,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: _primaryColor.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle:
                              const TextStyle(color: Colors.white),
                          defaultTextStyle: TextStyle(
                            color: isDarkMode ? Colors.white70 : _primaryColor,
                          ),
                          weekendTextStyle: TextStyle(
                            color: isDarkMode ? Colors.white70 : _primaryColor,
                          ),
                          outsideTextStyle: TextStyle(
                            color: isDarkMode ? Colors.white30 : Colors.grey,
                          ),
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            DateTime d = normalizeDate(day);
                            if (_predictedDays.contains(d) &&
                                !_selectedDays.contains(d)) {
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade300,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          titleTextStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _primaryColor,
                          ),
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: _primaryColor),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: _primaryColor),
                          headerPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey.shade900.withOpacity(0.7)
                    : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendaCirculo(color: _primaryColor, label: "Menstruação registrada"),
                  const SizedBox(width: 24),
                  _legendaCirculo(color: Colors.blue.shade300, label: "Menstruação prevista"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _legendaCirculo({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
