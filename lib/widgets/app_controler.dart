import 'package:flutter/material.dart';
import 'package:lumina/widgets/save_file_tema.dart';

class appcontroler extends ChangeNotifier {
  static final appcontroler instance = appcontroler._internal();

  bool isdarktheme = true;

  appcontroler._internal();

  void changeTheme() {
    isdarktheme = !isdarktheme;
    notifyListeners();
  }

  Future<void> loadThemeFromStorage() async {
    final storage = CounterStorage_tema();
    String theme = await storage.readCounter();
    isdarktheme = theme == "dark";
    notifyListeners();
  }
}
