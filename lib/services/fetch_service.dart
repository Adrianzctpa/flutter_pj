import '../models/people.dart';
import 'package:http/http.dart' as http;

class FetchService {
  final client = http.Client();
  final api = 'https://swapi.dev/api/people';

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

  Future<Getter?> getPeopleByPage(int num) async {
    final uri = Uri.parse('$api?page=$num');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = response.body;
      return getterFromJson(json);
    }

    return null;
  }
}
