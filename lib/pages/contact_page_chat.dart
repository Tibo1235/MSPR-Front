import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../models/user.dart';  // Assurez-vous d'importer UserInfo
import '/utility/providerUser.dart';
import 'package:dio/dio.dart';
import '../utility/web_socket_service.dart';
import '../utility/providerUserInfo.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<int> connectedUsers = []; // Liste des utilisateurs connectés
  List<UserInfo> contacts = [];  // Liste des contacts
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  final WebSocketService _webSocketService = WebSocketService();

  @override
  void initState() {
    super.initState();
    fetchContacts();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.userId;

    if (userId != null) {
      _webSocketService.connect(userId.toString()); // Connexion WebSocket avec l'ID de l'utilisateur
      _webSocketService.requestConnectedUsers(); // Demander la liste des utilisateurs connectés
    }
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  // Fonction pour récupérer les contacts depuis l'API
  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?.userId;

      if (userId == null) {
        throw Exception("User ID is null");
      }

      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer ${userProvider.user?.token}';

      final String url = 'http://10.0.2.2:3000/user/$userId';

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          setState(() {
            contacts = [UserInfo.fromJson(data)]; // Utilisez UserInfo ici
          });
        } else {
          throw Exception('No data found');
        }
      } else {
        throw Exception("Failed to load user data");
      }
    } catch (error) {
      print('Error fetching contacts: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading contacts')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fonction pour envoyer un message privé
  void sendMessage(String content, String receveurId) {
    final message = jsonEncode({
      'type': 'private_message',
      'content': content,
      'receveurId': receveurId,
    });
    _webSocketService.sendMessage(message);
  }

  // Mise à jour de la liste des utilisateurs connectés
  void updateConnectedUsers(List<int> users) {
    setState(() {
      connectedUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9DE),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xB2E1BD98),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search Contacts",
                    filled: true,
                    fillColor: const Color(0xA68A9B6E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Implémenter un filtrage des contacts si nécessaire
                  },
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : contacts.isEmpty
                    ? const Center(child: Text('No contacts found'))
                    : ListView.builder(
                  itemCount: connectedUsers.length,
                  itemBuilder: (context, index) {
                    final userId = connectedUsers[index];
                    return ListTile(
                      title: Text("User $userId"),
                      onTap: () => sendMessage("Hello", userId.toString()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
