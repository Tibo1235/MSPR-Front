import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utility/providerUser.dart';
import 'login_page.dart';
import 'package:dio/dio.dart';
import '/utility/providerUser.dart';

class UserBotanistRegistrationPage extends StatefulWidget {
  @override
  _UserBotanistRegistrationPageState createState() => _UserBotanistRegistrationPageState();
}

class _UserBotanistRegistrationPageState extends State<UserBotanistRegistrationPage> {
  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _acceptedPolicy = false;
  bool _isButtonEnabled = false;

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
    try {
      Dio dio = Dio();

      const String url = 'http://10.0.2.2:3000/users/botanists';

      FormData formData = FormData.fromMap({
        'email': emailController.text,
        'password': passwordController.text,
        'pseudo': pseudoController.text,
        'ville': cityController.text,
        'codePostal': postalCodeController.text,
        'roleId':2,
      });
      dio.options.headers['Authorization'] =
      'Bearer ${userProvider.user?.token}';
      final response = await dio.post(url, data: {
        'email': emailController.text,
        'password': passwordController.text,
        'pseudo': pseudoController.text,
        'ville': cityController.text,
        'codePostal': int.parse(postalCodeController.text),


      });
    }
    catch (error) {
      print('Erreur lors de la création de l\'annonce: $error');
    }
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
              Container(
                width: 500,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xA08A9B6E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: pseudoController,
                        decoration: InputDecoration(
                          labelText: 'Pseudo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
              Container(
                width: 500,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xA08A9B6E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Mail',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
              Container(
                width: 500,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xA08A9B6E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
              Container(
                width: 500,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xA08A9B6E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: postalCodeController,
                        decoration: InputDecoration(
                          labelText: 'Postal Code',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
              Container(
                width: 500,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xA08A9B6E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 350,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true, // Masque le texte saisi
                        decoration: InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.0),
              SizedBox(height: 14.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _acceptedPolicy,
                    onChanged: (value) {
                      setState(() {
                        _acceptedPolicy = value ?? false;
                        _checkFields(); // Appel à la fonction pour vérifier les champs
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              // Affichage du bouton "S'inscrire" uniquement si les conditions sont remplies
              if (_isButtonEnabled)
                GestureDetector(
                  onTap: () {
                    createAccount(userProvider);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),

                    );
                  },
                  child: Text(
                    "S'inscrire",
                    style: TextStyle(
                      color: Color(0xFF354733),
                      decoration: TextDecoration.underline,
                      fontSize: 30,

                    ),
                  ),
                ),
            ],
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
        child:
        (MaterialApp(

          home: UserBotanistRegistrationPage(),
        )
        ),
      ));
}