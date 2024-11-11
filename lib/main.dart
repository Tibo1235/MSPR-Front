import 'package:flutter/material.dart';
import 'package:lodim_mspr/pages/contact_page_chat.dart';
import 'package:lodim_mspr/pages/research_page.dart';
import 'package:provider/provider.dart';
import 'pages/account_creation.dart';
import 'pages/account_page.dart';
import 'pages/creation_fiche.dart';
import 'pages/login_page.dart';
import 'utility/providerUser.dart';

void main() {
  runApp(const MyApp());
} // runApp MyApp

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => UserProvider(),
        child: MaterialApp(
          home: LoginPage(),
        ),
    );
  }
}
