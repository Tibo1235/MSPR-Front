import 'package:flutter/material.dart';
import '/models/user.dart';
import '/utility/auth.dart';
import 'package:provider/provider.dart';
import '/utility/providerUser.dart'; // Le provider pour gérer l'utilisateur
import '/pages/accueil.dart';
import 'account_creation.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isButtonVisible = false;
  bool _isLoading = false; // Indicateur de chargement
  String? _errorMessage; // Message d'erreur éventuel

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(updateButtonVisibility);
    _passwordController.addListener(updateButtonVisibility);
  }

  void updateButtonVisibility() {
    setState(() {
      isButtonVisible = _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  Future<void> login(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Appel à la méthode d'authentification
    final user = await Auth.authenticate(email, password);

    if (user != null) {
      // Si l'authentification réussie, on met à jour le provider et navigue vers la page d'accueil
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Affichage de l'erreur si l'authentification échoue
      setState(() {
        _errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Identifiants incorrects. Veuillez réessayer.'),
      ));
    }

    setState(() {
      _isLoading = false;
    });
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

  @override
  Widget _page(BuildContext context) {
    return Stack(
      children: [
        // Image en bas
        Positioned(
          bottom: 0,
          left: -100,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/hand-leaf.png',
                width: 700,
                height: 400,
              ),
            ),
          ),
        ),
        // Image en haut à gauche
        Positioned(
          top: 20,
          left: -10,
          child: Image.asset(
            'assets/images/plante.png',
            width: 100,
            height: 100,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _icon(),
                  const SizedBox(height: 50),
                  _inputField("Email", _emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _inputField("Mot de passe", _passwordController, isPassword: true),
                  const SizedBox(height: 50),
                  _isLoading
                      ? CircularProgressIndicator()
                      : _loginBtn(context),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Divider(
                    color: Color(0xFF354733),
                    thickness: 5,
                    indent: 150,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        children: [
                          _signUpBtn(context),
                          _extraText(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              "Cultivez l'inspiration !",
              style: TextStyle(
                color: Color(0xFF354733),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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

  Widget _inputField(String hintText, TextEditingController controller, {bool isPassword = false, TextInputType? keyboardType}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Color(0xFF8A9B6E)),
    );
    return TextField(
      style: const TextStyle(color: Color(0xFF354733)),
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF354733)),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: const Color(0xA08A9B6E),
      ),
      obscureText: isPassword,
    );
  }

  Widget _loginBtn(BuildContext context) {
    return isButtonVisible
        ? Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () async { await login(context); },
            child: Text(
              "Se connecter",
              style: TextStyle(
                color: Color(0xFF4A6741),
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
        style: TextStyle(
          color: Color(0xFF4A6741),
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      "Vous n'arrivez pas à accéder à votre compte?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, color: Color(0xFF354733)),
    );
  }
}
