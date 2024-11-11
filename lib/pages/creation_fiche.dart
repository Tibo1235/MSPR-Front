import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '/models/fiche.dart'; // Importation du modèle Fiche
import '/models/user.dart'; // Importation du modèle User
import '../utility/providerUser.dart'; // Importation du package image

class CreateFichePage extends StatefulWidget {
  @override
  _CreateFichePageState createState() => _CreateFichePageState();
}

class _CreateFichePageState extends State<CreateFichePage> {
  // Liste pour stocker plusieurs images
  List<File> images = [];
  TextEditingController especesController = TextEditingController();
  TextEditingController contenuController = TextEditingController();

  // Variables manquantes
  File? photo; // Image actuellement sélectionnée
  String? _errorMessage; // Message d'erreur à afficher
  bool _isLoading = false; // État de chargement de la requête

  Future<void> _pickImages(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path)); // Ajouter l'image sélectionnée à la liste
      });
    }
  }

  Future<void> createFiche(User? user) async {
    try {
      setState(() {
        _isLoading = true; // Indiquer que le chargement commence
      });

      Dio dio = Dio();
      const String url = '/fiches';

      List<MultipartFile> photos = await Future.wait(images.map((image) async {
        return await MultipartFile.fromFile(image.path, filename: image.path.split('/').last);
      }));

      FormData formData = FormData.fromMap({
        'especes': especesController.text,
        'contenu': contenuController.text,
        'photos': photos,
      });

      // Ajouter le header d'autorisation
      dio.options.headers['Authorization'] = 'Bearer ${user?.token}';

      // Envoyer la requête POST
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fiche créée avec succès')),
        );
        Navigator.pop(context); // Revenir à la page précédente
      } else {
        setState(() {
          _errorMessage = 'Erreur lors de la création de la fiche: ${response.statusMessage}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur lors de la création de la fiche: $error';
      });
    } finally {
      setState(() {
        _isLoading = false; // Indiquer que le chargement est terminé
      });
    }
  }

  Future<void> submitForm(User? user) async {
    if (especesController.text.isNotEmpty && contenuController.text.isNotEmpty && images.isNotEmpty) {
      await createFiche(user);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Champs incomplets"),
            content: Text("Veuillez remplir tous les champs avant de soumettre."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBD6578), // Couleur de fond
                ),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Widget buildGridView() {
    return images.isEmpty
        ? SizedBox.shrink()
        : GridView.builder(
      itemCount: images.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        File image = images[index];
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => removeImage(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF8E9DE),
      appBar: AppBar(
        title: Text("Créer une Fiche"),
        backgroundColor: Color(0xFF8A9B6E),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xB2E1BD98),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Création d'une fiche conseil",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImages(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Sélectionner des images'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A9B6E),
                  ),
                ),
                SizedBox(height: 20),
                buildGridView(),
                SizedBox(height: 20),
                _buildTextField(
                  controller: especesController,
                  label: 'Espèce',
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: contenuController,
                  label: 'Description',
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    var user = userProvider.user;
                    if (user != null) {
                      submitForm(user);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Utilisateur non authentifié')),
                      );
                    }
                  },
                  child: Text('Créer la fiche'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF8A9B6E),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xA08A9B6E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        home: CreateFichePage(),
      ),
    ),
  );
}
