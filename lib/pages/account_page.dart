import 'package:flutter/material.dart';
import 'package:japx/japx.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '/models/user.dart';
import '/utility/providerUser.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isEditingPseudo = false;
  bool isEditingEmail = false;
  bool isEditingVille = false;
  bool isEditingCodePostal = false;

  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController villeController = TextEditingController();
  TextEditingController codePostalController = TextEditingController();

  Future<UserInfo> userInfos(user) async {
    Dio dio = Dio();

    try {
      final response = await dio.get(
        '/users/infos',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${user?.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.data);
        final data = decodedJson['data']['attributes'];
        return UserInfo.fromJson(data);
      } else {
        throw Exception('Failed to load User infos');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load User infos');
    }
  }

  void saveChanges(UserInfo userInfo) {
    // Implement your update logic here. For example:
    // Call an API to update the user info in the backend
    setState(() {
      isEditingPseudo = false;
      isEditingEmail = false;
      isEditingVille = false;
      isEditingCodePostal = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    const String assetName = 'assets/images/logo_svg.svg';
    final Widget svgIcon = SvgPicture.asset(
      assetName,
      width: 200,
      colorFilter: ColorFilter.mode(Colors.green.shade800, BlendMode.srcIn),
    );

    return FutureBuilder<UserInfo>(
      future: userInfos(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          }
          final userInfo = snapshot.data;

          pseudoController.text = userInfo?.pseudo ?? "";
          emailController.text = userInfo?.email ?? "";
          villeController.text = userInfo?.ville ?? "";
          codePostalController.text = userInfo?.codePostal ?? "";

          return Container(
            padding: EdgeInsets.all(20),
            color: Color(0xFFF8E9DE),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                svgIcon,
                SizedBox(height: 20),
                buildEditableField(
                  label: "Pseudo",
                  value: userInfo?.pseudo ?? "pseudo inconnu",
                  isEditing: isEditingPseudo,
                  controller: pseudoController,
                  onEdit: () {
                    setState(() {
                      isEditingPseudo = true;
                    });
                  },
                  onSave: () {
                    saveChanges(userInfo!);
                  },
                ),
                SizedBox(height: 8.0),
                buildEditableField(
                  label: "Email",
                  value: userInfo?.email ?? "email inconnu",
                  isEditing: isEditingEmail,
                  controller: emailController,
                  onEdit: () {
                    setState(() {
                      isEditingEmail = true;
                    });
                  },
                  onSave: () {
                    saveChanges(userInfo!);
                  },
                ),
                SizedBox(height: 8.0),
                buildEditableField(
                  label: "Ville",
                  value: userInfo?.ville ?? "Ville inconnue",
                  isEditing: isEditingVille,
                  controller: villeController,
                  onEdit: () {
                    setState(() {
                      isEditingVille = true;
                    });
                  },
                  onSave: () {
                    saveChanges(userInfo!);
                  },
                ),
                SizedBox(height: 8.0),
                buildEditableField(
                  label: "Code Postal",
                  value: userInfo?.codePostal ?? "Code Postal inconnu",
                  isEditing: isEditingCodePostal,
                  controller: codePostalController,
                  onEdit: () {
                    setState(() {
                      isEditingCodePostal = true;
                    });
                  },
                  onSave: () {
                    saveChanges(userInfo!);
                  },
                ),
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget buildEditableField({
    required String label,
    required String value,
    required bool isEditing,
    required TextEditingController controller,
    required VoidCallback onEdit,
    required VoidCallback onSave,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Color(0xA68A9B6E),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: isEditing
                ? TextField(
              controller: controller,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            )
                : Text(
              value,
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: isEditing ? onSave : onEdit,
        ),
      ],
    );
  }
}
