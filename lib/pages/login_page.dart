// pages/login_page.dart
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

    final user = await Auth.authenticate(email, password);

    if (user != null) {
      Provider.of<UserProvider>(context, listen: false).setUser(user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      setState(() {
        _errorMessage = 'Identifiants incorrects. Veuillez réessayer.';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Identifiants incorrects. Veuillez réessayer.',
        ),
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
              const SizedBox(height: 10),
              Divider(
                color: Color(0xFF354733),
                thickness: 5,
                indent: 40,
                endIndent: 40,
              ),
              const SizedBox(height: 5),
              _signUpBtn(context),
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
        ? ElevatedButton(
      onPressed: () async {
        await login(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF354733),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        "Se connecter",
        style: TextStyle(fontSize: 20, color: Colors.white),
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

  Widget _extraText() {
    return const Text(
      "Vous n'arrivez pas à accéder à votre compte?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Color(0xFF354733)),
    );
  }
}
