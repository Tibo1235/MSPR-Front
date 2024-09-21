import 'package:flutter/material.dart';

class Fiche {
  final String id;
  final String especes;
  final String contenu;
  List<Photo>? photos;

  Fiche({
    required this.id,
    required this.especes,
    required this.contenu,
    this.photos
  });

  factory Fiche.fromJson(Map<String, dynamic> json ) {
    List<Photo> photoList = (json['photos-plante'] as List)
      .map((photoJson) => Photo.fromJson(photoJson))
      .toList();

    return Fiche(
        id: json['id'] as String,
        especes : json['especes'] as String,
        contenu : json['contenu'] as String,
        photos: photoList
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

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String, // Conserver la valeur éventuelle de l'attribut id
      url: json['url'] as String,
    );
  }
}