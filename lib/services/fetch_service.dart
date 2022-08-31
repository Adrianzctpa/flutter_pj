import '../models/people.dart';
import 'package:http/http.dart' as http;

class FetchService {
  Future<List<Result>?> getPeople() async {
    final client = http.Client();
    final uri = Uri.parse('https://swapi.dev/api/people');
    
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final json = response.body;
      return peopleFromJson(json).results;
    }

    return null;
  }
}
