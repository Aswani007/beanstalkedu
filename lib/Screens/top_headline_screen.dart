import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:imversion/controller/topheadline.dart';

import '../models/article_model.dart';
import 'custom_news_container.dart';

class TopHeadLineScreen extends StatefulWidget {
  const TopHeadLineScreen({Key? key}) : super(key: key);

  @override
  State<TopHeadLineScreen> createState() => _TopHeadLineScreenState();
}

class _TopHeadLineScreenState extends State<TopHeadLineScreen> {

  final headlineService = Get.put(TopHeadLineService());
  int currentIndex = 0;
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffDEF5E5),
        appBar: AppBar(
          title: const Text("Top Headline"),
          backgroundColor: const Color(0xff8EC3B0),
        ),
        body: FutureBuilder(
            future: headlineService.topHeadlineData(),
            builder: (context, AsyncSnapshot<List<Article>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Loading..."),
                    ],
                  ),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, i) {
                      return CustomNewContainer(
                        article: snapshot.data![i],
                      );
                    });
              }
              return const Text("error");
            }));
  }
}
