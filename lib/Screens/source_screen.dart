import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imversion/Screens/custom_news_container.dart';

import '../controller/sourceService.dart';
import '../models/article_model.dart';


class SourceScreen extends StatelessWidget {
  SourceScreen({Key? key}) : super(key: key);
  final sourceService = Get.put(SourceService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Source"),backgroundColor: const Color(0xff8EC3B0),),
      body: FutureBuilder(future: sourceService.sourceData(),builder: (context,AsyncSnapshot<List<Article>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
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
        if(snapshot.hasData){
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, i) {
                return CustomNewContainer(
                  article: snapshot.data![i],
                );
              });
        }
        return const Text("error");
      },)
    );
  }
}
