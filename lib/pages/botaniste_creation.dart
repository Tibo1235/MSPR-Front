import 'package:flutter/material.dart';
import 'package:lodim_mspr/pages/post_creation.dart';
import 'creation_fiche.dart';

class BotanistChoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9DE), // Fond beige clair
      body: Stack(
        children: [
          // Décoration des feuilles en haut à gauche
          Positioned(
            top: 0,
            left: 0, // Positionné au coin supérieur gauche
            child: Image.asset(
              'assets/images/plante.png', // Assurez-vous d'avoir cette image dans vos assets
              fit: BoxFit.contain,
              height: 120, // Ajustez la hauteur selon vos besoins
            ),
          ),

          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // Logo centré
                Padding(
                  padding: const EdgeInsets.only(top: 50), // Abaisse le logo
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logoavecfond.png', // Assurez-vous d'avoir cette image dans vos assets
                        height: 100, // Taille ajustée du logo
                      ),
                    ],
                  ),
                ),

                // Espace pour positionner les boutons plus haut
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Premier bouton dans un container beige
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDDFCF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImagePickerApp(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB5C8B5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Créer une annonce',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Texte "Ou"
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10), // Diminue l'espace vertical
                            child: Text(
                              'Ou',
                              style: TextStyle(
                                color: Color(0xFF6B4D32),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          // Deuxième bouton dans un container beige
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDDFCF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateFichePage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFB5C8B5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Créer une fiche',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
