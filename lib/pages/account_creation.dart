import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utility/providerUser.dart';
import 'login_page.dart';
import 'package:dio/dio.dart';

class UserRegistrationPage extends StatefulWidget {
  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _acceptedPolicy = false;
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    pseudoController.addListener(_checkFields);
    emailController.addListener(_checkFields);
    cityController.addListener(_checkFields);
    postalCodeController.addListener(_checkFields);
    passwordController.addListener(_checkFields);
  }

  void _checkFields() {
    bool isFieldsFilled = pseudoController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        postalCodeController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    setState(() {
      _isButtonEnabled = isFieldsFilled && _acceptedPolicy;
    });
  }

  Future<void> createAccount() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Dio dio = Dio();

      // Remplacez par 10.0.2.2 pour un émulateur Android
      const String url = 'http://10.0.2.2:3000/users/user';

      // Conversion du code postal en entier
      int codePostal = int.tryParse(postalCodeController.text) ?? 0;

      // Préparation des données
      Map<String, dynamic> data = {
        'email': emailController.text,
        'password': passwordController.text,
        'pseudo': pseudoController.text,
        'ville': cityController.text,
        'codePostal': codePostal,
      };

      // Envoi de la requête POST
      final response = await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Compte créé avec succès, naviguer vers la page de connexion
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Gérer les autres statuts de réponse
        setState(() {
          _errorMessage =
          'Erreur lors de la création du compte: ${response.statusMessage}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur lors de la création du compte: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Libérer les contrôleurs
    pseudoController.dispose();
    emailController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E9DE),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoavecfond.png',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 14.0),
              _buildTextField(pseudoController, 'Pseudo'),
              SizedBox(height: 14.0),
              _buildTextField(emailController, 'Mail', keyboardType: TextInputType.emailAddress),
              SizedBox(height: 14.0),
              _buildTextField(cityController, 'City'),
              SizedBox(height: 14.0),
              _buildTextField(postalCodeController, 'Postal Code', keyboardType: TextInputType.number),
              SizedBox(height: 14.0),
              _buildTextField(passwordController, 'Password', obscureText: true),
              SizedBox(height: 14.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _acceptedPolicy,
                    onChanged: (value) {
                      setState(() {
                        _acceptedPolicy = value ?? false;
                        _checkFields();
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Vous acceptez les conditions d'utilisation de l'application",
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _isButtonEnabled ? createAccount : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF354733),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "S'inscrire",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: const Color(0xA08A9B6E),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: UserRegistrationPage(),
      ),
    ),
  );
}
