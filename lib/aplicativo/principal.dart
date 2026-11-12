import 'package:flutter/material.dart';
import 'package:lumina/aplicativo/autocuidado.dart';
import 'package:lumina/aplicativo/calendario.dart';
import 'package:lumina/aplicativo/estatisticas.dart';
import 'package:lumina/aplicativo/home.dart';
import 'package:lumina/aplicativo/perfil.dart';
import 'package:lumina/widgets/color.dart';

class principal extends StatefulWidget {
  const principal({super.key});

  @override
  State<principal> createState() => PrincipalState();
}
class PrincipalState extends State<principal> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    Container(child: autocuidado()),
    Container(child: calendario()),
    Container(child: home()),
    Container(child: estatisticas()),
    Container(child: perfil()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // <-- Método público para ser chamado da home
  void selectPage(int index) {
    _onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 225, 177, 193),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Autocuidado'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendário'),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Estatísticas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: hexColor("#bc244c"),
        unselectedItemColor: const Color.fromARGB(255, 247, 129, 129),
        onTap: _onItemTapped,
      ),
    );
  }
}