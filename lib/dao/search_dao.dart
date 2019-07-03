import 'package:http/http.dart' as http;
import 'package:flutter_trip/model/search_model.dart';
import 'dart:convert';

class SearchDao {
  static Future<SearchModel> fetch(String url, String keyword) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Codec utf8codec = Utf8Codec();
      final result = SearchModel.fromJson(
          json.decode(utf8codec.decode(response.bodyBytes)));
      result.keyword = keyword;
      return result;
    } else {
      throw Exception('Faild to load search result');
    }
  }
}
