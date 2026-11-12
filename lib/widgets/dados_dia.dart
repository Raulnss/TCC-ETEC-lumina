import 'package:flutter/material.dart';

class DadosDia {
  List<String> humores;
  List<String> sintomas;
  String fluxo;
  String anotacao;

  DadosDia({
    List<String>? humores,
    List<String>? sintomas,
    this.fluxo = "Moderado",
    this.anotacao = "",
  })  : humores = humores ?? [],
        sintomas = sintomas ?? [];

  static final Map<String, IconData> iconesHumores = {
    "Irritada": Icons.sentiment_very_dissatisfied,
    "Pouca energia": Icons.battery_alert,
    "Tristeza": Icons.sentiment_dissatisfied,
    "Calma": Icons.sentiment_satisfied_alt,
    "Ansiedade": Icons.sentiment_very_satisfied,
    "Sono excessivo": Icons.bedtime,
    "Mudanças de humor": Icons.change_circle,
    "Apática": Icons.sentiment_neutral,
  };

  DadosDia clone() {
    return DadosDia(
      humores: List<String>.from(humores),
      sintomas: List<String>.from(sintomas),
      fluxo: fluxo,
      anotacao: anotacao,
    );
  }

  void toggleHumor(String h) {
    humores.contains(h) ? humores.remove(h) : humores.add(h);
  }

  void toggleSintoma(String s) {
    sintomas.contains(s) ? sintomas.remove(s) : sintomas.add(s);
  }

  static const List<String> humoresDisponiveis = [
    "Irritada",
    "Pouca energia",
    "Tristeza",
    "Calma",
    "Ansiedade",
    "Sono excessivo",
    "Mudanças de humor",
    "Apática"
  ];

  static const List<String> sintomasDisponiveis = [
    "Seios sensíveis",
    "Cólicas",
    "Inchaço abdominal",
    "Dor de cabeça",
    "Náusea",
    "Acne",
    "Alterações no apetite",
    "Cansaço",
    "Dor nas costas",
    "Pele mais oleosa",
    "Tontura",
    "Pele mais seca"
  ];

  static const List<String> fluxosDisponiveis = [
    "Leve",
    "Moderado",
    "Forte"
  ];
}