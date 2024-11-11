import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
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

  final Dio dio = Dio();

  Future<UserInfo> userInfos(user) async {
    try {
      // Configurer l'en-tête d'autorisation pour Dio
      dio.options.headers['Authorization'] = 'Bearer ${user?.token}';

      // Effectuer la requête GET avec Dio
      final response = await dio.get('/users/infos');

      // Vérifier si la requête a réussi
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = response.data;
        final data = decodedJson['data']['attributes'];
        return UserInfo.fromJson(data);
      } else {
        throw Exception('Failed to load User infos');
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
      throw e;
    }
  }

  void saveChanges(UserInfo userInfo) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        if (isEditing)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                ),
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: onSave,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: Text(value),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),
      ],
    );
  }
}
