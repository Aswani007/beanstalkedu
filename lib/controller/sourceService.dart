import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class SourceService extends GetxController{
  RxList sourceList = <String>[].obs;

  void addSource(String sourceText){
    sourceList.add(sourceText);
    update();
  }

  Future<List<Article>> sourceData() async {
    final url = Uri.parse("https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&apiKey=7c16618422e9461397e1376ec291642c");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> extractedNews = json.decode(response.body);
      List<dynamic> body = extractedNews["articles"];
      List<Article> articles =
      body.map((dynamic items) => Article.fromJson(items)).toList();
      return articles;
    } else {
      throw ("Cannot get the articles");
    }
  }


}