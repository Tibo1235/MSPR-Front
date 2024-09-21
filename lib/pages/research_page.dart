//Pour tous les utilisateurs
//Permet de faire une recherche dans les annonces
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:japx/japx.dart';
import '/models/annonce.dart';
import 'package:provider/provider.dart';
import '/pages/detail_annonce.dart';
import '/utility/providerUser.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  List<Annonce> searchResults = [];
  String searchTerm = "";


  Future<List<Annonce>> fetchAnnoncesFromApi(user) async {
    var response;
    if (searchTerm == "")
    {
      response = await http.get(Uri.parse('/annonces/search?termeRecherche=""'),
          headers: {
          'Authorization': 'Bearer ${user?.token}'
          });
    }
    else {
      response = await http.get(Uri.parse(
          '/annonces/search?termeRecherche=${searchTerm}'),
          headers: {
            'Authorization': 'Bearer ${user?.token}'
          });
    }
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      final Map<String, dynamic> decodedJson = Japx.decode(json.decode(response.body));
      final List<dynamic> data = decodedJson['data'];
      List to_sort = data.map((json) => Annonce.fromJson(json)).toList();
      List<Annonce>return_list = [];
      for (var annonce in to_sort) {
        if (annonce.is_conseil == "true") {
          return_list.add(annonce);
        }
      }
      return return_list;
    } else {
      throw Exception('Failed to load annonce');
    }
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context).user;
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Effectuer une recherche',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchTerm = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Entrez votre terme de recherche',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            final apiArticles = await fetchAnnoncesFromApi(user);
                            searchResults = apiArticles;
                            setState(() {});
                          } catch (e) {
                            print('Error fetching articles: $e');
                          }
                        },
                        child: const Text('Rechercher'),
                      ),
                      if (searchResults.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            const Text(
                              'Résultats de la recherche :',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            // Affichez les résultats de la recherche avec ListView.builder
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: searchResults.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    //Naviguer vers la page de détails de l'article
                                    Navigator.push(
                                      context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewAnnonce(annonce: searchResults[index]),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Text(searchResults[index].titre),
                                      subtitle: Text("annonce"),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ] else ...[
                        const SizedBox.shrink(),
                      ],
                    ],
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