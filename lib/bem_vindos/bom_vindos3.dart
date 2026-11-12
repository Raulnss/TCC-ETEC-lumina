import 'package:flutter/material.dart';
import 'package:lumina/acesso/login.dart';
import 'package:lumina/widgets/color.dart';

class bem_vindos3  extends StatefulWidget {
  const bem_vindos3({super.key});

  @override
  State<bem_vindos3> createState() => bem_vindos3State();
}
class bem_vindos3State extends State<bem_vindos3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( 
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'CADA CICLO É\n ÚNICO, ASSIM\n COMO VOCÊ',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: hexColor("#bc244c"),  
              ),
            ),
            SizedBox(height: 30),
            Image.asset(
              'assets/image_boa_vindas_atualizado3.png',
              height: 300, 
            ),
            SizedBox(height: 20), 
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Agora, queremos conhecer melhor você e seu bem-estar para cuidar de você com mais carinho',
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
              ],
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => login()),
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
