import 'package:flutter/material.dart';

Color hexColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex'; // adiciona opacidade
  return Color(int.parse('0x$hex'));
}