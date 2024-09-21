//Page pour tout le monde
//Permet de voir le détail de l'annonce avant de la poster
import 'package:flutter/material.dart';
import '../models/annonce.dart';
import '../models/user.dart';



class ViewAnnonce extends StatefulWidget {
  final Annonce annonce;


  const ViewAnnonce({super.key, required this.annonce});


  @override
  State<ViewAnnonce> createState() => _ViewAnnonceState();
}


class _ViewAnnonceState extends State<ViewAnnonce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('View Annonce')),
      backgroundColor: Color(0xFFF8E9DE), //Attention avant de mettre une couleur en hexadecimal il faut mettre 0xFF /!\
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
                  width:400,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Color(0xFFE1BD98),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text(
                          widget.annonce.titre,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF354733),
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          widget.annonce.pseudo,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
//il faudra mettre les photos ici
//il faudra mettre le conseil ici
                        SizedBox(height: 16.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Container(
                                  width:170,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8A9B6E),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:Center(
                                    child:Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          Text(
                                            'Date de début : ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF354733),
                                                fontSize: 16,
                                                decoration: TextDecoration.underline
                                            ),
                                          ),
                                          Text(
                                            widget.annonce.date_debut.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF354733),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ]
                                    ),
                                  )
                              ),
                              Container(
                                  width:170,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8A9B6E),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:Center(
                                    child:Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          Text(
                                            'Date de fin : ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFF354733),
                                                fontSize: 16,
                                                decoration: TextDecoration.underline
                                            ),
                                          ),
                                          Text(
                                            widget.annonce.date_fin.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF354733),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ]
                                    ),
                                  )
                              ),
                            ]
                        ),
                        SizedBox(height: 16.0),
                        Container(
                            width:350,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF8A9B6E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:Center(
                              child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(
                                      'Espèce :  ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xFF354733),
                                          fontSize: 16,
                                          decoration: TextDecoration.underline
                                      ),
                                    ),
                                    Text(
                                      widget.annonce.titre,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF354733),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ]
                              ),
                            )


                        ),
                        SizedBox(height: 16.0),
                        Container(
                            width:350,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xFF8A9B6E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child:Center(
                              child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    Text(
                                      'Description : ',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xFF354733),
                                          fontSize: 16,
                                          decoration: TextDecoration.underline
                                      ),
                                    ),
                                    Text(
                                      widget.annonce.description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF354733),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ]
                              ),
                            )
                        ),
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

