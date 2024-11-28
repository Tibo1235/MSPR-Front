class User {
  String? token;
  final int userId;
  final String role;

  User({
    this.token,
    required this.userId,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as int,
      role: json['role'] as String,
    );
  }
}

class UserInfo {
  final String id;           // Gardez-les comme String
  final String pseudo;
  final String email;
  final String ville;
  final String codePostal;
  final String roleId;       // Gardez également ce champ comme String

  UserInfo({
    required this.id,
    required this.pseudo,
    required this.email,
    required this.ville,
    required this.codePostal,
    required this.roleId,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
// Assurez-vous de convertir correctement les valeurs en String si nécessaire
    return UserInfo(
      id: json['id'].toString(),  // Convertir l'ID en String
      pseudo: json['pseudo'] as String,
      email: json['email'] as String,
      ville: json['ville'] as String,
      codePostal: json['codePostal'].toString(), // Convertir codePostal en String
      roleId: json['roleId'].toString(),  // Convertir roleId en String
    );
  }
}