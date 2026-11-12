import 'package:flutter/material.dart';

class customTextfiel {
  final String title;
  final String placehouter;
  final bool inPass;
  String err;
  String _value = "";
  bool _obscureText = true; // Adicione esta linha
  customTextfiel({
    this.title = "",
    this.placehouter = "",
    this.inPass = false,
    this.err = "Inscira todos os campos",
  });

  TextFormField textFormField({VoidCallback? toggle}) {
    return TextFormField(
      onChanged: (value) {
        _value = value;
      },
      validator: (value) => value!.isEmpty ? err : null,
      obscureText: inPass && _obscureText, // Use a variável _obscureText aqui
      style: TextStyle(color: const Color.fromARGB(255, 225, 30, 95), fontSize: 16),
      decoration: InputDecoration(
        hintText: placehouter,
        hintStyle: TextStyle(color: Colors.grey),
        labelText: title,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 225, 30, 95), fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromARGB(255, 225, 30, 95)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromARGB(255, 225, 30, 95), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: const Color.fromARGB(255, 225, 30, 95)),
        ),
        prefixIcon: _getPrefixIcon(),
        suffixIcon: title == "Sua senha" || title == "Confirme sua senha" || title == "Sua nova senha"
        ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromARGB(255, 225, 30, 95),
            ),
            onPressed: () {
              _toggleObscureText();
              if (toggle != null) toggle(); // Atualiza o estado do StatefulBuilder
            },
          )
        : null,
      ),
    );
  }

  Widget _getPrefixIcon() {
    if (title == "Seu email") {
      return Icon(Icons.email, color: const Color.fromARGB(255, 225, 30, 95));
    } else if (title == "Sua senha" || title == "Confirme sua senha" || title == "Sua nova senha") {
      return Icon(Icons.lock_outline, color: const Color.fromARGB(255, 225, 30, 95));
    } else {
      return SizedBox.shrink();
    }
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    // Você precisará chamar setState() para reconstruir o widget
    // Isso precisa ser feito no widget pai (loginState)
  }

  String get value {
    return _value;
  }
}
