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

  @override
  Widget _page(BuildContext context) {
    return Stack(
      children: [
        // Ajout de l'image "hand-leaf.png" en bas au centre avec transparence
        Positioned(
          bottom: 0,
          left: -100,
          right: 0,
          child: Center(
            child: Opacity(
              opacity: 0.9, // Ajustez la valeur de transparence
              child: Image.asset(
                'assets/images/hand-leaf.png',
                width: 700, // Ajustez la taille de l'image
                height: 400, // Ajustez la taille de l'image
              ),
            ),
          ),
        ),
        // Ajout de l'image de la plante en haut à gauche
        Positioned(
          top: 20, // Ajustez selon vos besoins
          left: -10, // Ajustez selon vos besoins
          child: Image.asset(
            'assets/images/plante.png', // Remplacez par le chemin de votre image
            width: 100, // Ajustez la taille selon vos besoins
            height: 100, // Ajustez la taille selon vos besoins
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
                  const SizedBox(height: 10),
                  _guestModeBtn(context), // Bouton invité ajouté ici
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
                      width: MediaQuery.of(context).size.width * 0.5, // Réduction à 50% de la largeur
                      child: Column(
                        children: [
                          _signUpBtn(context), // Bouton d'inscription
                          _extraText(), // Texte pour accéder au compte
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
          bottom: 20, // Positionnement en bas de l'écran
          left: 0,   // Positionnement à gauche de l'écran
          child: RotatedBox(
            quarterTurns: 3, // Rotation à 270 degrés (90° * 3)
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
      padding: const EdgeInsets.only(right: 20.0), // Ajuste cet espacement selon vos besoins
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () async {
              await login(context);
            },
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
        : SizedBox(); // Renvoie un SizedBox vide si le bouton n'est pas visible
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
          fontSize: 25, // Réduction de la taille de la police
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _guestModeBtn(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(), // Remplacez par une page dédiée au mode invité si nécessaire
          ),
        );
      },
      child: Text(
        "",
        style: TextStyle(
          color: Color(0xFF4A6741),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      "Vous n'arrivez pas à accéder à votre compte?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, color: Color(0xFF354733)), // Réduction de la taille de la police
    );
  }
}
