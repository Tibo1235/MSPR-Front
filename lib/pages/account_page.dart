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

  Future<UserInfo> userInfos(User? user) async {
    if (user == null || user.userId == null) {
      throw Exception("L'utilisateur ou son userId est null");
    }

    try {
      dio.options.headers['Authorization'] = 'Bearer ${user.token}';
      final String url = 'http://10.0.2.2:3000/user/${user.userId}';

      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          return UserInfo.fromJson(data);
        } else {
          throw Exception('Les informations de l\'utilisateur sont manquantes dans la réponse');
        }
      } else {
        throw Exception('Échec de la récupération des informations utilisateur');
      }
    } catch (e) {
      print('Erreur lors de la récupération des informations utilisateur: $e');
      throw e;
    }
  }

  Future<void> updateUser(UserInfo updatedUser, User? user) async {
    if (user == null || user.userId == null) {
      throw Exception("L'utilisateur ou son userId est null");
    }

    try {
      dio.options.headers['Authorization'] = 'Bearer ${user.token}';
      final String url = 'http://10.0.2.2:3000/user/${user.userId}';

      final Map<String, dynamic> data = {
        "email": updatedUser.email,
        "pseudo": updatedUser.pseudo,
        "ville": updatedUser.ville,
        "codePostal": updatedUser.codePostal,
        "roleId": user.role, // Ajoutez le roleId de l'utilisateur
      };

      final response = await dio.put(
        url,
        data: jsonEncode(data),
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        print("Utilisateur mis à jour avec succès !");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur mis à jour avec succès !")),
        );
      } else {
        throw Exception('Erreur lors de la mise à jour : ${response.data}');
      }
    } catch (e) {
      print("Erreur lors de la mise à jour de l'utilisateur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la mise à jour.")),
      );
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

    final updatedUser = UserInfo(
      id: userInfo.id,
      pseudo: pseudoController.text,
      email: emailController.text,
      ville: villeController.text,
      codePostal: codePostalController.text,
      roleId: userInfo.roleId, // Assurez-vous de conserver le roleId
    );

    updateUser(updatedUser, Provider.of<UserProvider>(context, listen: false).user);
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
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFF8E9DE),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                svgIcon,
                const SizedBox(height: 20),
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
                const SizedBox(height: 8.0),
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
                const SizedBox(height: 8.0),
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
                const SizedBox(height: 8.0),
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        if (isEditing)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
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
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),
      ],
    );
  }
}
