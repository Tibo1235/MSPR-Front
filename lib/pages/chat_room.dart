import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../utility/web_socket_service.dart';
import '../utility/providerUserInfo.dart';
import '../utility/providerUser.dart';

class Message {
  final String text;
  final String alignment;
  final File? image;

  Message({required this.text, required this.alignment, this.image});
}

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final List<Message> messages = [];
  final TextEditingController messageController = TextEditingController();
  String selectedAlignment = 'Left';
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();
  final WebSocketService _webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.userId;
    if (userId != null) {
      _webSocketService.connect(userId.toString());
      _webSocketService.setOnMessageReceived((message) {
        setState(() {
          messages.add(Message(
            text: message,
            alignment: 'Left', // Adjust alignment as needed
          ));
        });
      });
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  void sendMessage() async {
    if (messageController.text.trim().isNotEmpty || messages.isNotEmpty) {
      // Envoyer le message texte
      if (messageController.text.trim().isNotEmpty) {
        setState(() {
          messages.add(Message(
            text: messageController.text.trim(),
            alignment: selectedAlignment,
          ));
        });
        messageController.clear();
      }

      // Envoyer l'image
      if (messages.last.image != null) {
        try {
          FormData formData = FormData.fromMap({
            'image': await MultipartFile.fromFile(
              messages.last.image!.path,
              filename: 'image.jpg',
            ),
          });

          Response response = await _dio.post(
            'http://localhost:3000', // Remplacez par votre endpoint
            data: formData,
            options: Options(
              headers: {
                'Content-Type': 'multipart/form-data',
              },
            ),
          );

          print(response.data); // Réponse de l'API

          // Vous pouvez traiter la réponse de l'API ici selon votre besoin

        } catch (e) {
          print('Error sending image: $e');
        }
      }

      // Envoyer le message via WebSocket
      final message = jsonEncode({
        'type': 'private_message',
        'content': messageController.text.trim(),
      });
      _webSocketService.sendMessage(message);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        messages.add(Message(
          text: '',
          alignment: selectedAlignment,
          image: File(pickedFile.path),
        ));
      });
    }
  }

  void showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8E9DE),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0, top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danny Hopknis',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Quicksand',
                    color: Colors.black,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedAlignment,
                  items: <String>['Left', 'Right'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAlignment = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xB2E1BD98),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '28 JUNE 23:41',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ...messages.map((message) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: message.alignment == 'Right'
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (message.image != null)
                                Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xff8a9b6e),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      message.image!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (message.text.isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color(0xff8a9b6e),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      message.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file),
                  onPressed: () {
                    showImageSourceActionSheet(context);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onSubmitted: (value) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatRoomScreen(),
  ));
}
