import 'dart:convert';

import 'package:login/models/dog.dart';
import 'package:http/http.dart' as http;

class DogService {
  static const String dogceoUrl = "https://dog.ceo/api/breeds/image/random";
  Future<Dog> getRandomDog() async {
    final response = await http.get(Uri.parse(dogceoUrl));

    if (response.statusCode == 200) {
      return Dog.fromJson(jsonEncode(response.body) as Map<String, dynamic>);
    }
    throw Exception("Erro interno, chama o dev ${response.statusCode}");
  }
}
