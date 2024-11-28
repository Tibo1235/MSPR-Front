import 'dart:convert';
import 'dart:io';

class WebSocketService {
  WebSocket? _channel;

  // Connexion WebSocket avec l'ID de l'utilisateur
  Future<void> connect(String userId) async {
    try {
      // Attente de la connexion avant d'assigner à la variable
      _channel = await WebSocket.connect('ws://10.0.2.2:4000?id=$userId');

      // Dès que la connexion est établie, écoute les messages
      _channel?.listen((message) {
        _onMessage(message);
      }, onError: (error) {
        print('WebSocket error: $error');
      }, onDone: () {
        print('WebSocket closed');
      });
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  }

  // Déconnexion WebSocket
  void disconnect() {
    _channel?.close();
  }

  // Envoi de message au serveur WebSocket
  void sendMessage(String message) {
    if (_channel != null && _channel?.readyState == WebSocket.open) {
      _channel?.add(message);
    }
  }

  // Demande des utilisateurs connectés
  void requestConnectedUsers() {
    if (_channel != null && _channel?.readyState == WebSocket.open) {
      final message = jsonEncode({
        'type': 'get_connected_users',
      });
      _channel?.add(message);
    }
  }

  // Gestion des messages reçus
  void _onMessage(dynamic message) {
    final data = jsonDecode(message);
    if (data['type'] == 'connected_users') {
      // Cette méthode sera appelée pour mettre à jour la liste des utilisateurs connectés
      print('Users connected: ${data['users']}');
      // Vous pouvez notifier votre UI via un provider ou autre
    }
  }
}
