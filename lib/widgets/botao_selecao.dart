import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BotaoSelecao extends StatelessWidget {
  final String texto;
  final bool selecionado;
  final VoidCallback onTap;
  final IconData? icone;
  final String? svgIcon; // para ícones SVG

  const BotaoSelecao({
    super.key,
    required this.texto,
    required this.selecionado,
    required this.onTap,
    this.icone,
    this.svgIcon,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = selecionado ? Colors.white : Colors.pink;

    Widget iconWidget;

    if (selecionado) {
      iconWidget = const Icon(
        Icons.check,
        color: Colors.white,
        size: 22,
      );
    } else if (svgIcon != null) {
      iconWidget = SvgPicture.asset(
        svgIcon!,
        width: 22,
        height: 22,
        color: iconColor,
      );
    } else if (icone != null) {
      iconWidget = Icon(
        icone,
        color: iconColor,
        size: 22,
      );
    } else {
      iconWidget = Icon(
        Icons.circle,
        color: iconColor,
        size: 22,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selecionado ? Colors.pink : Colors.transparent,
                border: Border.all(color: Colors.pink, width: 2),
                shape: BoxShape.circle,
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 6),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
                color: Colors.pink.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}