import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '/models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Auth {

  static Future<User?> authenticate(String email, String password) async {
    try {
      var response = await http.post(

          Uri.parse('/users/auth'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String> {
            'email': email,
            'password': password
          })
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String token = data['token'];
        JWT jwt;
        jwt = JWT.decode(token);
        User user = User.fromJson(jwt.payload);
        user.token = token;
        if (data != null && data.containsKey('token')) {
          return user;
        }
      }
    }
    on SocketException catch (e) {
      print('Network error: $e');
      return null;
    }
    on http.ClientException catch (e) {
      print('HTTP error: $e');
      return null;
    }
    catch (e) {
      print('Unexpected error: $e');
      return null;
    }
    return null;
  }
}
