import 'package:flutter/material.dart';
import 'package:lumina/bem_vindos/bom_vindos3.dart';
import 'package:lumina/widgets/color.dart';

class bemvindos2 extends StatefulWidget {
  const bemvindos2({super.key});

  @override
  State<bemvindos2> createState() => bemvindos2State();
}

class bemvindos2State extends State<bemvindos2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( 
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'CONHECER SEU\n CICLO É PODER',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: hexColor("#bc244c"), 
              ),
            ),
            SizedBox(height: 30),
            Image.asset(
              'assets/image_boa_vindas_atualizado2.png',
              height: 300, 
            ),
            SizedBox(height: 20), 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Acompanhe sua menstruação, anote seus sintomas e muito mais!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: hexColor("#bc244c"), ),
              ),
            ),
            SizedBox(height: 30),
            
            SizedBox(height: 20), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => bem_vindos3()),
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
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
