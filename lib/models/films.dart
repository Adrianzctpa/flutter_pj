import 'dart:convert';

FilmsGetter filmsFromJson(String str) => FilmsGetter.fromJson(json.decode(str));

String filmsToJson(FilmsGetter data) => json.encode(data.toJson());

Films filmFromJson(String str) => Films.fromJson(json.decode(str));

class FilmsGetter {
    FilmsGetter({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });

    final int count;
    final dynamic next;
    final dynamic previous;
    final List<Films> results;

    factory FilmsGetter.fromJson(Map<String, dynamic> json) => FilmsGetter(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Films>.from(json["results"].map((x) => Films.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "Films": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}

class Films {
    Films({
        required this.title,
        required this.episodeId,
        required this.openingCrawl,
        required this.director,
        required this.producer,
        required this.releaseDate,
        required this.characters,
        required this.planets,
        required this.starships,
        required this.vehicles,
        required this.species,
        required this.created,
        required this.edited,
        required this.url,
    });

    final String title;
    final int episodeId;
    final String openingCrawl;
    final String director;
    final String producer;
    final DateTime releaseDate;
    final List<String> characters;
    final List<String> planets;
    final List<String> starships;
    final List<String> vehicles;
    final List<String> species;
    final DateTime created;
    final DateTime edited;
    final String url;

    factory Films.fromJson(Map<String, dynamic> json) => Films(
        title: json["title"],
        episodeId: json["episode_id"],
        openingCrawl: json["opening_crawl"],
        director: json["director"],
        producer: json["producer"],
        releaseDate: DateTime.parse(json["release_date"]),
        characters: List<String>.from(json["characters"].map((x) => x)),
        planets: List<String>.from(json["planets"].map((x) => x)),
        starships: List<String>.from(json["starships"].map((x) => x)),
        vehicles: List<String>.from(json["vehicles"].map((x) => x)),
        species: List<String>.from(json["species"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        edited: DateTime.parse(json["edited"]),
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "episode_id": episodeId,
        "opening_crawl": openingCrawl,
        "director": director,
        "producer": producer,
        "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "characters": List<dynamic>.from(characters.map((x) => x)),
        "planets": List<dynamic>.from(planets.map((x) => x)),
        "starships": List<dynamic>.from(starships.map((x) => x)),
        "vehicles": List<dynamic>.from(vehicles.map((x) => x)),
        "species": List<dynamic>.from(species.map((x) => x)),
        "created": created.toIso8601String(),
        "edited": edited.toIso8601String(),
        "url": url,
    };
}
