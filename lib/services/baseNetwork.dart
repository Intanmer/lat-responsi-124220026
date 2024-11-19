import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static Future<List<dynamic>> get(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return List<dynamic>.from(json.decode(response.body)['results']);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }
}