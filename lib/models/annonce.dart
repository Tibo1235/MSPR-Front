import 'package:flutter/material.dart';

class Annonce {
  final String id;
  final String titre;
  final String pseudo;
  final String proprioEmail;
  final List<Plante>? planteList;
  final String? date_debut;
  final String? date_fin;
  final String description;
  final String? is_conseil;




  Annonce({
    required this.id,
    required this.titre,
    required this.pseudo,
    required this.proprioEmail,
    required this.description,
    this.date_debut,
    this.date_fin,
    this.planteList,
    this.is_conseil
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {


    List<Plante> planteList = (json['plantes-annonce'] as List)
        .map((planteJson) => Plante.fromJson(planteJson))
        .toList();

    return Annonce(
        id: json['id'] as String,
        titre: json['titre'] as String,
        pseudo: json['proprietaire']['pseudo'] as String,
        proprioEmail: json['proprietaire']['email'] as String,
        description: json['description'] as String,
        date_debut: json['date-debut'] as String?,
        date_fin: json['date-fin'] as String?,
        is_conseil : json['is-conseil'] as String?,
        planteList: planteList
    );
  }
}


class Plante {
  final String id;
  final String espece;
  final List<Photo>? photoList;

  Plante({
    required this.espece,
    required this.id,
    this.photoList
  });

  factory Plante.fromJson(Map<String, dynamic>json){

    List<Photo> photoListFactory = (json['photos-plante'] as List)
        .map((photoJson) => Photo.fromJson(photoJson))
        .toList();

    return Plante(
        id: json['id'] as String,
        espece:json['espece'] as String,
        photoList: photoListFactory
    );
  }
}

class Photo {
  final String id;
  final String url;

  Photo({
    required this.url,
    required this.id,
  });

  factory Photo.fromJson(Map<String, dynamic>json){
    return Photo(
      id: json['id'] as String,
      url:json['url'] as String,
    );
  }
}