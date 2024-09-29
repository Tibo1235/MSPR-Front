import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '/models/fiche.dart';
import '/models/user.dart'; 
import '../utility/providerUser.dart';

class CreateFichePage extends StatefulWidget {
  @override
  _CreateFichePageState createState() => _CreateFichePageState();
}

class _CreateFichePageState extends State<CreateFichePage> {
  File? photo;
  List<File> images = [];
  TextEditingController especesController = TextEditingController();
  TextEditingController contenuController = TextEditingController();

  Future<void> _pickPhoto(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        photo = File(pickedFile.path);
      });
    }
  }

  Future<void> createFiche(User? user) async {
    try {
      Dio dio = Dio();

      // URL de l'API pour créer une fiche
      const String url = 'http://10.2.0.0:3000/fiches'; // Update to your actual API endpoint

      FormData formData = FormData.fromMap({
        'especes': especesController.text,
        'contenu': contenuController.text,
        'usersId': user?.userId, // Use userId here
        'photos': await MultipartFile.fromFile(photo!.path, filename: 'photo.jpg'),
      });

      dio.options.headers['Authorization'] = 'Bearer ${user?.token}';

      print('Envoi de la requête avec les données :');
      print('Espèces : ${especesController.text}');
      print('Contenu : ${contenuController.text}');
      print('Photo : ${photo!.path}');
      // Envoi de la requête HTTP POST avec le corps JSON de la fiche
      final response = await dio.post(url, data: formData);

      // Vérifier le statut de la réponse
      if (response.statusCode == 201) {
        // Fiche créée avec succès
        // Afficher un message ou effectuer une action
      } else {
        throw Exception('Failed to create fiche');
      }
    } catch (error) {
      print('Erreur lors de la création de la fiche: $error');
      // Gérer l'erreur comme nécessaire
    }
  }

  Future<void> getImage(ImageSource source) async {
    final imageTemporary = await ImagePicker().pickImage(source: source);
    if (imageTemporary != null) {
      setState(() {
        photo = File(imageTemporary.path);
      });
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
        : GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        File image = images[index];
        Uint8List imageBytes = image.readAsBytesSync();
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              child: Image.memory(
                Uint8List.fromList(imageBytes),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => removeImage(index),
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> submitForm(User? user) async {
    try {
      if (especesController.text.isNotEmpty &&
          contenuController.text.isNotEmpty) {
        createFiche(user);
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
    } catch (error) {
      print('Erreur lors de la création de la fiche: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8E9DE),
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
                ElevatedButton(
                  onPressed: () => getImage(ImageSource.camera),
                  child: Text('Sélectionner une image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A9B6E),
                  ),
                ),
                SizedBox(height: 20),
                buildGridView(),
                SizedBox(height: 20),
                TextField(
                  controller: especesController,
                  decoration: InputDecoration(labelText: 'Espèce'),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: contenuController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    var user = Provider.of<UserProvider>(context, listen: false).user;
                    if (user != null) {
                      submitForm(user);
                    }
                  },
                  child: Text('Créer la fiche'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF8A9B6E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
