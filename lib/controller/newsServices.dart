import 'dart:convert';

import 'package:get/get.dart';
import 'package:imversion/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/source_models.dart';

class NewsService extends GetxController {
  RxList bookMarkNews = <Article>[].obs;

  RxString searchText = "bitcoin".obs;
  RxString sortText = "relevancy".obs;

  Future<List<Article>> newsData() async {
    final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=${searchText
            .value}&sortBy=${sortText
            .value}&apiKey=7c16618422e9461397e1376ec291642c");
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

  void addBookmark(Article article){
    bookMarkNews.insert(0,Article(
        source: Source(id: article.source.id, source: article.source.source),
        author: article.author,
        title: article.title,
        url: article.url,
        urlToImage: article.urlToImage,
        publishedAt: article.publishedAt,
        bookmarked: article.bookmarked));
    update();
  }



  Future<void> saveBookmarkToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List items = bookMarkNews.map((e) {
      return {
        "source":{
          "id": e.source.id,
          "source" : e.source.source,
        },
        "author": e.author ?? "",
        "title": e.title,
        "url": e.url,
        "urlToImage": e.urlToImage,
        "publishedAt": e.publishedAt,
        "bookmarked": e.bookmarked
      };
    }).toList();
    print(items);
    await prefs.setString("articles", json.encode(items));
    print("added");
  }

  Future<void> fetchSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("articles")) {
      return;
    } else {
      String data = prefs.getString("articles")!;
      List savedData = json.decode(data);
      for (var i in savedData) {
        bookMarkNews.add(Article(source: Source(id: i["source"]["id"], source: i["source"]["source"]),
            author: i["author"],
            title: i["title"],
            url: i["url"],
            urlToImage: i["urlToImage"],
            publishedAt: i["publishedAt"],
            bookmarked: i["bookmarked"]));
      }
    }
  }

// Future<void> newsData([bool filter = false,bool search = false]) async {
//   final url = Uri.parse(
//       "https://newsapi.org/v2/everything?q=bitcoin&apiKey=7c16618422e9461397e1376ec291642c");
//   final response = await http.get(url);
//   if (response.statusCode == 200) {
//     Map<String, dynamic> extractedNews = json.decode(response.body);
//     final body = extractedNews["articles"];
//     for (var i in body) {
//       allNews.add(Article.fromJson(i));
//     }
//     update();
//   } else {
//     throw ("Cannot get the articles");
//   }
// }
}
