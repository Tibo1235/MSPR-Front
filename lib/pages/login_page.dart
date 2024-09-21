//Page pour tous les utilisateurs
//Permet de se connecter à l'application
import 'package:flutter/material.dart';
import '/models/user.dart';
import '../utility/auth.dart';
import 'package:provider/provider.dart';
import '/utility/providerUser.dart';
import '/pages/accueil.dart';


import 'account_creation.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isButtonVisible = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(updateButtonVisibility);
    _passwordController.addListener(updateButtonVisibility);
  }

  void updateButtonVisibility() {
    setState(() {
      isButtonVisible = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  Future<void> login(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final user = await Auth.authenticate(username, password);

    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Identifiants incorrects. Veuillez réessayer.',
        ),
      ));
    }
  }

  void accessAsGuest(BuildContext context) {
    // Redirige directement vers la page d'accueil sans authentification
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8E9DE),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(context),
      ),
    );
  }

  Widget _page(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _icon(),
              const SizedBox(height: 50),
              _inputField("Email", _usernameController),
              const SizedBox(height: 20),
              _inputField("Mot de passe", _passwordController, isPassword: true),
              const SizedBox(height: 50),
              _loginBtn(context),
              const SizedBox(height: 10),
              Divider(
                color: Color(0xFF354733),
                thickness: 5,
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(height: 5),
              _signUpBtn(context),
              const SizedBox(height: 20),
              _guestAccessBtn(context),  // Bouton pour accès en tant qu'invité
              const SizedBox(height: 20),
              _extraText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      child: Image.asset(
        'assets/images/logoavecfond.png',
        width: 250,
        height: 250,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFF8A9B6E)),
    );
    return TextField(
      style: const TextStyle(color: Color(0xFF354733)),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF354733)),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: Color(0xA08A9B6E),
      ),
      obscureText: isPassword,
    );
  }

  Widget _loginBtn(BuildContext context) {
    return isButtonVisible
        ? TextButton(
      onPressed: () async {
        await login(context);
      },
      child: Text(
        "Se connecter",
        style: TextStyle(fontSize: 20, color: Color(0xFF354733)),
      ),
    )
        : SizedBox();
  }

  Widget _signUpBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserRegistrationPage()),
        );
      },
      child: Text(
        "S'inscrire",
        style: TextStyle(fontSize: 20, color: Color(0xFF354733)),
      ),
    );
  }

  Widget _guestAccessBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        accessAsGuest(context);
      },
      child: Text(
        "Accès Invité",
        style: TextStyle(fontSize: 20, color: Color(0xFF354733)), // Couleur du texte
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      "Vous n'arrivez pas à accéder à votre compte?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Color(0xFF354733)),
    );
  }
}