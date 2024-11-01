import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/utility/providerUser.dart';
import 'package:http_parser/http_parser.dart';

class ImagePickerApp extends StatefulWidget {
  @override
  _ImagePickerAppState createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  List<File> images = [];
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titreController = TextEditingController();
  List<TextEditingController> especeControllers = [TextEditingController(), TextEditingController()];
  List<TextEditingController> pseudoControllers = [TextEditingController(), TextEditingController()];

  Future<void> getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;

    setState(() {
      images.add(File(pickedImage.path));
    });
  }

  Future<void> createAnnonce(UserProvider userProvider) async {
    try {
      Dio dio = Dio();

      // URL de l'API pour créer une annonce
      const String url = 'http://localhost:3000/annonces'; // Update to your actual API endpoint

      List<MultipartFile> multipartFiles = [];

      FormData formData = FormData.fromMap({
        'date_debut': startDate?.toLocal().toString().split(' ')[0],
        'date_fin': endDate?.toLocal().toString().split(' ')[0],
        'description': descriptionController.text,
        'titre': titreController.text,
        'usersId': userProvider.user?.userId, // Add user ID to the FormData
        'espece[0]': especeControllers[0].text,
        'espece[1]': especeControllers[1].text,
        'pseudo[0]': pseudoControllers[0].text,
        'pseudo[1]': pseudoControllers[1].text,
      }, ListFormat.multiCompatible);

      for (var file in images) {
        formData.files.add(
          MapEntry(
            "photos[]",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: MediaType("image", "jpeg"),
            ),
          ),
        );
      }

      dio.options.headers['Authorization'] = 'Bearer ${userProvider.user?.token}';

      print("${userProvider.user?.token}");

      print('Envoi de la requête avec les données :');
      print('Date Début : ${startDate?.toLocal().toString().split(' ')[0]}');
      print('Date Fin : ${endDate?.toLocal().toString().split(' ')[0]}');
      print('Description : ${descriptionController.text}');
      print('Titre : ${titreController.text}');
      print('Photos : ${images.map((image) => image.path).toList()}');
      print('Espèces : ${especeControllers.map((controller) => controller.text).toList()}');
      print('Pseudos : ${pseudoControllers.map((controller) => controller.text).toList()}');

      // Envoi de la requête HTTP POST avec le corps JSON de l'annonce
      final response = await dio.post(url, data: formData);

      // Vérifier le statut de la réponse
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Annonce créée avec succès!')),
        );
        setState(() {
          images.clear();
          startDate = null;
          endDate = null;
          descriptionController.clear();
          titreController.clear();
          especeControllers.forEach((controller) => controller.clear());
          pseudoControllers.forEach((controller) => controller.clear());
        });
      } else {
        throw Exception('Failed to create annonce');
      }
    } catch (error) {
      print('Erreur lors de la création de l\'annonce: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création de l\'annonce')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation de Provider.of pour obtenir l'instance de UserProvider
    final userProvider = Provider.of<UserProvider>(context);

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
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xA68A9B6E),
                      ),
                      onPressed: () => _selectDate(context, true),
                      child: Text("Date de début"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xA68A9B6E),
                      ),
                      onPressed: () => _selectDate(context, false),
                      child: Text("Date de fin"),
                    ),
                  ],
                ),
                SizedBox(height: 8.0), // Espace entre les boutons et le texte
                if (startDate != null || endDate != null) ...[
                  Text(
                    "Date de début : ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Non sélectionnée'}",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Date de fin : ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Non sélectionnée'}",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
                SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    filled: true,
                    fillColor: Color(0xA68A9B6E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: titreController,
                  decoration: InputDecoration(
                    labelText: "Titre",
                    filled: true,
                    fillColor: Color(0xA68A9B6E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () => getImage(ImageSource.camera),
                      tooltip: 'Prendre une photo',
                    ),
                    IconButton(
                      icon: Icon(Icons.photo_library),
                      color: Colors.white,
                      iconSize: 50,
                      onPressed: () => getImage(ImageSource.gallery),
                      tooltip: 'Sélectionner une image',
                    ),
                  ],
                ),
                if (images.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(images[index], height: 100, width: 100),
                          );
                        },
                      ),
                    ),
                  ),
                SizedBox(height: 16.0),
                ...List.generate(especeControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: especeControllers[index],
                      decoration: InputDecoration(
                        labelText: "Espèce ${index + 1}",
                        filled: true,
                        fillColor: Color(0xA68A9B6E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  );
                }),
                ...List.generate(pseudoControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: pseudoControllers[index],
                      decoration: InputDecoration(
                        labelText: "Pseudo ${index + 1}",
                        filled: true,
                        fillColor: Color(0xA68A9B6E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => createAnnonce(userProvider),
                  child: Text('Créer Annonce'),
                ),
              ],
            ),
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
        home: ImagePickerApp(),
      ),
    ),
  );
}
