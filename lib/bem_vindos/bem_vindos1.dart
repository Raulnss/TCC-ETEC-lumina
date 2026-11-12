import 'package:flutter/material.dart';
import 'package:lumina/bem_vindos/bem_vindos2.dart';
import 'package:lumina/widgets/color.dart';

class bemvindos1 extends StatefulWidget {
  const bemvindos1({super.key});

  @override
  State<bemvindos1> createState() => bemvindos1State();
}

class bemvindos1State extends State<bemvindos1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( 
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'BEM VINDA\n AO LÚMINA',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: hexColor("#bc244c"), 
              ),
            ),
            SizedBox(height: 30),
            Image.asset(
              'assets/image_boa_vindas_atualizado1.png',
              height: 300, 
            ),
            SizedBox(height: 20), 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Aqui você contará com um aplicativo para ajudar a controlar o seu ciclo mestrual',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: hexColor("#bc244c"), ),
              ),
            ),
            SizedBox(height: 30),
            
            SizedBox(height: 20), // Espaço entre o botão e os indicadores
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hexColor("#bc244c"),
                  ),
                ),
                SizedBox(width: 70),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink[200], 
                  ),
                ),
                SizedBox(width: 70),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink[200], 
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => bemvindos2()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[200],
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text('Seguir',
              style: TextStyle(color: hexColor("#bc244c"), ),
              ),
            ),
            SizedBox(height: 50), // Espaço inferior
          ],
        ),
      ),
    );
  }
}
