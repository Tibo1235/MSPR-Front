import 'package:flutter/material.dart';
import 'account_admin_creation.dart';
import 'account_botaniste_creation.dart';
import 'account_creation.dart';

class ViewChoiceAdmin extends StatefulWidget {
  @override
  State<ViewChoiceAdmin> createState() => _ViewChoiceAdminState();
}

class _ViewChoiceAdminState extends State<ViewChoiceAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFFF8E9DE),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoentier.png',
                width: 200,
                height: 200,
              ),
              SizedBox(height: 16.0),
              Container(
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BD98),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE1BD98),
                    foregroundColor: const Color(0xFF354733),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserRegistrationAdminPage()),
                    );
                  },
                  child: Text(
                    'Inscrire un administrateur',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF354733),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OU',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color(0xFF354733),
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BD98),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE1BD98),
                    foregroundColor: const Color(0xFF354733),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserBotanistRegistrationPage()),
                    );
                  },
                  child: Text(
                    'Inscrire un botaniste',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF354733),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'OU',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: const Color(0xFF354733),
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: 400,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1BD98),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE1BD98),
                    foregroundColor: const Color(0xFF354733),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserRegistrationPage()),
                    );
                  },
                  child: Text(
                    'Inscrire un utilisateur',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: const Color(0xFF354733),
                      fontSize: 30,
                    ),
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
