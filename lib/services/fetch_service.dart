import '../models/people.dart';
import '../models/films.dart';
import 'package:http/http.dart' as http;
import '../utils/swapi_routes.dart';

class FetchService {
  final client = http.Client();
  final api = SWAPIRoutes.swAPI;
  final filmsAPI = SWAPIRoutes.filmsAPI;

  Future<Films?> genericFetcher(String uri) async {
    final response = await client.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      final json = response.body;
      return filmFromJson(json);
    }

    return null;
  }

  Future<Getter?> getFilms() async {
    final response = await client.get(Uri.parse(filmsAPI));
    if (response.statusCode == 200) {
      final json = response.body;
      return getterFromJson(json);
    }

    return null;
  }

  Future<Getter?> getFilmsByName(String name) async {
    final response = await client.get(Uri.parse('$filmsAPI?search=$name'));
    if (response.statusCode == 200) {
      final json = response.body;
      return getterFromJson(json);
    }

    return null;
  }

  Future<Getter?> getPeople() async {   
    final uri = Uri.parse(api);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = response.body;
      return getterFromJson(json);
    }

    return null;
  }

  Future<Getter?> getPeopleByName(String name) async {
    final uri = Uri.parse('$api?search=$name');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = response.body;
      return getterFromJson(json);
    }

    return null;
  }

  Future<Getter?> getPeopleByPage(int num, [String filter = '']) async {
    final uri = filter == '' 
    ? Uri.parse('$api?page=$num') 
    : Uri.parse('$api?search=$filter&page=$num');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = response.body;
      return getterFromJson(json);
    }

    return null;
  }
}
