import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/user.dart';

class Auth {
  static const String loginUrl = 'http://10.0.2.2:3000/users/auth';
  static final Dio dio = Dio(); // Initialiser Dio

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

      if (response.statusCode == 200) {
        var data = response.data;
        String token = data['token'];
        Map<String, dynamic> userData = data['user'];
        User user = User.fromJson(userData);
        user.token = token;

        // Stocker le token en utilisant SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);

        return user;
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      if (e.error is SocketException) {
        print('Network error: $e');
      } else {
        print('Dio error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }


  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token'); // Récupérer le token stock
  }
}