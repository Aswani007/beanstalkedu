import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imversion/controller/newsServices.dart';

import '../models/article_model.dart';


class BookmarkScreen extends StatelessWidget {
  BookmarkScreen({Key? key}) : super(key: key);
  final newsS = Get.put(NewsService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bookmarks"),backgroundColor: const Color(0xff8EC3B0)),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
            itemCount: newsS.bookMarkNews.length,
            itemBuilder: (ctx, i) {
              return CustomBookmarkScreen(
                article: newsS.bookMarkNews[i],
              );
            })
      ),
    );
  }
}

class CustomBookmarkScreen extends StatefulWidget {
  final Article article;
  const CustomBookmarkScreen({Key? key,required this.article}) : super(key: key);

  @override
  State<CustomBookmarkScreen> createState() => _CustomBookmarkScreenState();
}

class _CustomBookmarkScreenState extends State<CustomBookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(5),
      height: size.height * 0.4,
      width: size.width * 0.3,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            )
          ]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.25,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.article.urlToImage),
                    fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Card(
                      color: Colors.deepPurpleAccent.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          textScaleFactor: 1.2,
                          widget.article.source.source,
                          style: GoogleFonts.lexendDeca(fontSize: 9),
                        ),
                      )),
                  const Spacer(),
                  const Icon(Icons.star,color: Colors.yellow,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
              child: Text(
                widget.article.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
                style: GoogleFonts.lexendDeca(fontSize: 15),
              ),
            )
          ]),
    );
  }
}
