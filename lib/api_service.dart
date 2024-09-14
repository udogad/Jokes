import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiUrl =
      'https://official-joke-api.appspot.com/random_joke'; // Example API URL

  Future<Map<String, dynamic>> fetchJoke() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Joke not funny enough');
    }
  }
}
