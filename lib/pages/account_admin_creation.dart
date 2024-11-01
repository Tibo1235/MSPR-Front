import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utility/providerUser.dart';
import 'login_page.dart';
import 'package:dio/dio.dart';

class UserRegistrationAdminPage extends StatefulWidget {
  @override
  _UserRegistrationAdminPageState createState() => _UserRegistrationAdminPageState();
}

class _UserRegistrationAdminPageState extends State<UserRegistrationAdminPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _acceptedPolicy = false;
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  String? _errorMessage;

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

  Future<void> createAccount(UserProvider userProvider) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Dio dio = Dio();

      const String baseUrl = 'http://10.2.0.0:3000'; // Remplacez par l'URL de votre backend
      String url = '$baseUrl/users';

      // Préparez les données à envoyer
      Map<String, dynamic> data = {
        'email': emailController.text,
        'password': passwordController.text,
        'pseudo': pseudoController.text,
        'ville': cityController.text,
        'codePostal': postalCodeController.text,
        'roleId': 1,
      };

      // Ajoutez l'en-tête d'autorisation si nécessaire
      dio.options.headers['Authorization'] = 'Bearer ${userProvider.user?.token}';
      dio.options.headers['Content-Type'] = 'application/json';

      final response = await dio.post(url, data: data);

      if (response.statusCode == 201) {
        // Compte créé avec succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compte créé avec succès')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() {
          _errorMessage = 'Erreur lors de la création du compte: ${response.statusMessage}';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erreur lors de la création du compte: $error';
      });
      print('Erreur lors de la création du compte: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    pseudoController.addListener(_checkFields);
    emailController.addListener(_checkFields);
    cityController.addListener(_checkFields);
    postalCodeController.addListener(_checkFields);
    passwordController.addListener(_checkFields);
  }

  @override
  void dispose() {
    pseudoController.dispose();
    emailController.dispose();
    cityController.dispose();
    postalCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
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
              SizedBox(height: 20),
              _buildTextField(
                controller: pseudoController,
                label: 'Pseudo',
              ),
              SizedBox(height: 14.0),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 14.0),
              _buildTextField(
                controller: cityController,
                label: 'Ville',
              ),
              SizedBox(height: 14.0),
              _buildTextField(
                controller: postalCodeController,
                label: 'Code Postal',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 14.0),
              _buildTextField(
                controller: passwordController,
                label: 'Mot de Passe',
                obscureText: true,
              ),
              SizedBox(height: 14.0),
              Row(
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
                    child: GestureDetector(
                      onTap: () {
                        // Action à effectuer lorsqu'on clique sur le texte de la politique
                      },
                      child: Text(
                        'J\'accepte les termes et conditions',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : _isButtonEnabled
                  ? ElevatedButton(
                onPressed: () {
                  createAccount(userProvider);
                },
                child: Text("S'inscrire"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF354733), padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ElevatedButton(
                onPressed: null,
                child: Text("S'inscrire"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF354733).withOpacity(0.5), padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: const Color(0xA08A9B6E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
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
        home: UserRegistrationAdminPage(),
      ),
    ),
  );
}
