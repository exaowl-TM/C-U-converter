import 'dart:convert';

import 'package:http/http.dart' as http;

//functions here take needed parameters and return list of data

const apiBase = "api.frankfurter.dev";

Future<double> convert(String base, String quote, num amount) async {
  final uri = Uri.https(apiBase, "v2/rate/$base/$quote");
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    final rate = (jsonResponse['rate'] as num).toDouble();
    return rate * amount;
  } else {
    throw Exception("failed to fitch data (convert ${response.statusCode})");
  }
}
