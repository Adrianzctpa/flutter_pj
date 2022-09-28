import 'dart:convert';

Getter getterFromJson(String str) => Getter.fromJson(json.decode(str));

String getterToJson(Getter data) => json.encode(data.toJson());

class Getter {
    Getter({
      required this.count,
      required this.next,
      required this.previous,
      required this.results,
    });

    final int count;
    final String? next;
    final dynamic previous;
    final List<People>? results;

    factory Getter.fromJson(Map<String, dynamic> json) { 
     return Getter(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<People>.from(json["results"].map((x) => People.fromJson(x))),
    );}

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
    };
}

class People {
    People({
      required this.name,
      required this.height,
      required this.mass,
      required this.hairColor,
      required this.skinColor,
      required this.eyeColor,
      required this.birthYear,
      required this.gender,
      required this.homeworld,
      required this.films,
      required this.species,
      required this.vehicles,
      required this.starships,
      required this.created,
      required this.edited,
      required this.url,
      required this.id
    });

    final String name;
    final String height;
    final String mass;
    final String hairColor;
    final String skinColor;
    final String eyeColor;
    final String birthYear;
    final String gender;
    final String homeworld;
    List<String> films = [];
    List<String> species = [];
    List<String> vehicles = [];
    List<String> starships = [];
    final DateTime created;
    final DateTime edited;
    final String url;
    final int id;

    factory People.fromJson(Map<String, dynamic> rawJson) {
      final checkList = ['films', 'species', 'vehicles', 'starships'];

      Map<String, dynamic> json = rawJson;

      for (var i = 0; i < checkList.length; i++) {
        final key = checkList[i];
        if (json[key] == null) {
          json[key] = ['none'];
        }
      }

      final RegExp getNumbersFromStr = RegExp(r'[^0-9]');
      final id = int.parse(json['url'].replaceAll(getNumbersFromStr, ''));

      return People(        
        name: json["name"],
        height: json["height"],
        mass: json["mass"],
        hairColor: json["hair_color"],
        skinColor: json["skin_color"],
        eyeColor: json["eye_color"],
        birthYear: json["birth_year"],
        gender: json["gender"],
        homeworld: json["homeworld"],
        films: List<String>.from(json["films"].map((x) => x)),
        species: List<String>.from(json["species"].map((x) => x)),
        vehicles: List<String>.from(json['vehicles'].map((x) => x)),  
        starships: List<String>.from(json["starships"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        edited: DateTime.parse(json["edited"]),
        url: json["url"],
        id: id
      );
    }

    Map<String, dynamic> toJson() => {
        "name": name,
        "height": height,
        "mass": mass,
        "hair_color": hairColor,
        "skin_color": skinColor,
        "eye_color": eyeColor,
        "birth_year": birthYear,
        "gender": gender,
        "homeworld": homeworld,
        "films": List<dynamic>.from(films.map((x) => x)),      
        "species": List<dynamic>.from(species.map((x) => x)),
        "vehicles": List<dynamic>.from(vehicles.map((x) => x)),      
        "starships": List<dynamic>.from(starships.map((x) => x)),
        "created": created.toIso8601String(),
        "edited": edited.toIso8601String(),
        "url": url,
        "id": id
    };
}