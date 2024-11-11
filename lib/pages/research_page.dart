import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
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
    try {
      final dio = Dio();
      Response response;

      response = await dio.get(
        '/annonces/search',
        queryParameters: {'termeRecherche': searchTerm},
        options: Options(headers: {
          'Authorization': 'Bearer ${user?.token}',
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = Japx.decode(response.data);
        final List<dynamic> data = decodedJson['data'];

        List<Annonce> returnList = data
            .map((json) => Annonce.fromJson(json))
            .where((annonce) => annonce.is_conseil == "true")
            .toList();

        return returnList;
      } else {
        throw Exception('Failed to load annonces');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load annonces');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    Widget _icon() {
      return Container(
        child: Image.asset(
          'assets/images/logoavecfond.png',
          width: 250,
          height: 250,
        ),
      );
    }

    return Container(
      color: const Color(0xFFF8E9DE), // Fond blanc
      child: Stack(
        children: [
          // Ajout des images en arrière-plan
          Positioned(
            top: 20,
            left: -10,
            child: Image.asset(
              'assets/images/plante.png',
              width: 100,
              height: 100,
            ),
          ),
          // Contenu principal
          Column(
            children: [
              const SizedBox(height: 20), // Laisser de la place pour les images
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _icon(),
                        const SizedBox(height: 0),
                        Card(
                          color: const Color(0xFFE1BD98), // Couleur de la Card
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            searchTerm = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Recherche',
                                          fillColor: Colors.green.shade100,
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 20),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () async {
                                        try {
                                          final apiArticles =
                                          await fetchAnnoncesFromApi(user);
                                          setState(() {
                                            searchResults = apiArticles;
                                          });
                                        } catch (e) {
                                          print('Error fetching articles: $e');
                                        }
                                      },
                                      icon: const Icon(Icons.search),
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                if (searchResults.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Résultats de la recherche :',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    itemCount: searchResults.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewAnnonce(
                                                      annonce:
                                                      searchResults[index]),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          child: ListTile(
                                            title: Text(
                                                searchResults[index].titre),
                                            subtitle: const Text("annonce"),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        home: SearchPage(),
      ),
    ),
  );
}
