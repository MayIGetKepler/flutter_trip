import 'package:flutter_trip/model/home_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';
class HomeDao {
  static Future<HomeModel> fetch() async{
    final response  = await http.get(HOME_URL);
    if(response.statusCode == 200){
      Utf8Codec utf8codec = Utf8Codec();
      final result =  json.decode(utf8codec.decode(response.bodyBytes));
      return HomeModel.fromJson(result);
    }else{
      throw Exception('Faild to load home page data');
    }
  }
}