import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shield_command_center/models/cat_fact_model.dart';

Future<CatFact> fetchCatFact() async {
  final response = await http.get(Uri.parse('https://catfact.ninja/fact'));

  if (response.statusCode == 200) {
    return CatFact.fromJson(json.decode(response.body));
  } else {
    throw Exception('failed to get cat fact');
  }
}
