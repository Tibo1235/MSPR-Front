//Page pour le botaniste
//Permet de choisir entre créer une annonce, créer une fiche ou valider les annonces
import 'package:flutter/material.dart';
import '/pages/post_creation.dart';
import 'creation_fiche.dart';

class ViewChoiceBotanist extends StatefulWidget {

  @override
  State<ViewChoiceBotanist> createState() => _ViewChoiceBotanistState();
}

class ChoiceBotanist {}

class _ViewChoiceBotanistState extends State<ViewChoiceBotanist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFF8E9DE), // Attention avant de mettre une couleur en hexadecimal il faut mettre 0xFF /!\
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoentier.png',
                width: 200,
                height: 200,
              ),
              Container(
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BD98),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE1BD98), // background (button) color
                    foregroundColor: const Color(0xFF354733), // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImagePickerApp()),
                    );
                  },
                  child: Text(
                    'Créer une annonce',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF354733),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OU',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color(0xFF354733),
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BD98),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE1BD98), // background (button) color
                    foregroundColor: const Color(0xFF354733), // text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateFichePage()),
                    );
                  },
                  child: Text(
                    'Créer une fiche conseil',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF354733),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OU',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color(0xFF354733),
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BD98),
                  borderRadius: BorderRadius.circular(20),
                ),
                  child: Text(
                    'Valider des annonces',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF354733),
                      fontSize: 30,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
