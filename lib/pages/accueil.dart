import 'package:flutter/material.dart';
import '/utility/providerUser.dart';
import 'package:provider/provider.dart';
import '/pages/research_page.dart';
import '/pages/account_page.dart';
import '/pages/post_creation.dart';
import 'account_creation.dart';
import 'adminChoice.dart';
import 'botanistChoice.dart';
import 'detail_annonce.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Provider.of<UserProvider>(context).user?.role == 'ADMIN' ? true : false;
    bool isBotaniste = Provider.of<UserProvider>(context).user?.role == 'BOTANISTE' ? true : false;

    return Scaffold(
      //appBar: AppBar(
        //title: [
         // Text("Bienvenue ${Provider.of<UserProvider>(context).user?.userId ?? "Accueil"}"),
          //Text("Liste des fiches conseils"),
          //if(isAdmin || isBotaniste)Text("Choix")
          //else Text("Créer une annonce"),
          //Text("Détails du compte"),
          //Text("Add annonce")
        //][_currentIndex],
      //),
      body: [
        //SearchPage(),
        ViewChoiceAdmin(),
        // AnnounceValidationPage(),
        if(isAdmin || isBotaniste )ViewChoiceBotanist()
        else ImagePickerApp(),
        //if(isAdmin)ViewChoiceAdmin(),
        SearchPage(),
        AccountPage()

      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setCurrentIndex(index),
        items: [
          /*BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Annonce',
            backgroundColor: Colors.green
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates),
            label: 'Fiche',
              backgroundColor: Colors.green
          ),
          if (isAdmin || isBotaniste)
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Ajouter',
                backgroundColor: Colors.green
            )
          else
            BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Ajouter',
                backgroundColor: Colors.green
            ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Recherche',
                backgroundColor: Colors.green
            ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
              backgroundColor: Colors.green
          ),
        ],
      ),
    );
  }
}
