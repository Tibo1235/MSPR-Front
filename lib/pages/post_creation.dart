import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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

  Future<String> imageToBase64(File imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    List<int> intList = bytes.cast<int>(); // Convert Uint8List to List<int>
    String base64Image = base64Encode(intList);
    return base64Image;
  }

  Future<void> createAnnonce(UserProvider userProvider) async {
    try {
      Dio dio = Dio();
      const String url = 'http://10.0.2.2:3000/annonce/';

      List<String> base64Images = [];
      for (var file in images) {
        String base64Image = await imageToBase64(file);
        base64Images.add(base64Image);
      }

      List<MultipartFile> multipartFiles = [];
      FormData formData = FormData.fromMap({
        'date_debut': startDate?.toIso8601String(),
        'date_fin': endDate?.toIso8601String(),
        'description': descriptionController.text,
        'titre': titreController.text,
        'isConseil': false, // Add a default value or retrieve it from the UI
        'gardeId': userProvider.user?.userId, // Ensure this matches the expected field name
        'espece': especeControllers.map((controller) => controller.text).toList(),
        'pseudo': pseudoControllers.map((controller) => controller.text).toList(),
        'photos': base64Images,
      });

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

      final response = await dio.post(url, data: formData);

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
        throw Exception('Erreur lors de la création de l\'annonce: ${response.data}');
      }
    } catch (error) {
      print('Erreur lors de la création de l\'annonce: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la création de l\'annonce: $error')),
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
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF8E9DE),
      body: SingleChildScrollView(
        child: Center(
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
                SizedBox(height: 8.0),
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
                SizedBox(height: 16.0),
                if (images.isNotEmpty)
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.file(
                                images[index],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    images.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(especeControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                  ),
                ),
                SizedBox(height: 16.0),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: List.generate(pseudoControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
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
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xA68A9B6E),
                  ),
                  onPressed: () {
                    if (images.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Veuillez ajouter des images')),
                      );
                    } else {
                      createAnnonce(userProvider);
                    }
                  },
                  child: Text("Créer l'annonce"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
