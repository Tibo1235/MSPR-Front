import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/user.dart';

class Auth {
  static const String loginUrl = 'http://10.0.2.2:3000/user/login';
  static final Dio dio = Dio();

  static Future<User?> authenticate(String email, String password) async {
    try {
      var response = await dio.post(
        loginUrl,
        data: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      // Log complet de la réponse
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.statusCode == 200) {
        var data = response.data;

        // Vérifiez que le token et l'utilisateur sont bien présents
        if (data.containsKey('token') && data.containsKey('user')) {
          String token = data['token'];
          Map<String, dynamic> userData = data['user'];

          User user = User.fromJson(userData);
          user.token = token;

          // Stockez le token
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          return user;
        } else {
          print('Invalid response structure: missing token or user key');
          return null;
        }
      } else {
        print('Login failed: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('DioError occurred: ${e.message}');
      if (e.response != null) {
        print('DioError response data: ${e.response?.data}');
      }
      return null;
    } catch (e) {

    }
  }
  }