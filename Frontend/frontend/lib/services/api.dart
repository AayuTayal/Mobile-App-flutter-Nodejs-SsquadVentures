import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main.dart';
import '../models/category.dart';
import '../models/filters.dart';
import '../models/banquet_request.dart';

class Api {
  static Future<List<Category>> fetchCategories() async {
    final r = await http.get(Uri.parse('$apiBase/api/categories'));
    final data = jsonDecode(r.body) as List;
    return data.map((e) => Category.fromJson(e)).toList();
  }

  static Future<Filters> fetchFilters() async {
    final r = await http.get(Uri.parse('$apiBase/api/venues/filters'));
    final data = jsonDecode(r.body);
    return Filters.fromJson(data);
  }

  static Future<String?> submitRequest(BanquetRequest req) async {
    final r = await http.post(
      Uri.parse('$apiBase/api/venues/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );
    if (r.statusCode >= 400) throw Exception(r.body);

    final decoded = jsonDecode(r.body);
    return decoded['id'] != null ? decoded['id'] as String : null;
  }
}
