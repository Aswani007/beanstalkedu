import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imversion/Screens/webview_screen.dart';
import 'package:imversion/models/article_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imversion/models/source_models.dart';

import '../controller/newsServices.dart';
import '../controller/sourceService.dart';

class CustomNewContainer extends StatefulWidget {
  final Article article;

  const CustomNewContainer({Key? key, required this.article}) : super(key: key);

  @override
  State<CustomNewContainer> createState() => _CustomNewContainerState();
}

class _CustomNewContainerState extends State<CustomNewContainer> {
  bool _bookmarked = false;
  NewsService newsS = Get.find();
  final sourceService = Get.put(SourceService());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Get.to(()=>WebViewScreenNews(title: widget.article.title,url: widget.article.url,));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
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
                    IconButton(onPressed: (){
                      sourceService.addSource(widget.article.source.source);

                    }, icon: Icon(Icons.save,color: Colors.redAccent.withOpacity(0.6),)),
                    const Spacer(),
                    IconButton(
                        onPressed: (){
                          setState(() {
                            _bookmarked = !_bookmarked;
                          });
                          if(_bookmarked){
                            if(newsS.bookMarkNews.where((p) => p.title == widget.article.title).isNotEmpty){
                              return;
                            }
                            else{
                              newsS.addBookmark(Article(
                                  source: Source(
                                      id: widget.article.source.id,
                                      source: widget.article.source.source),
                                  author: widget.article.author,
                                  title: widget.article.title,
                                  url: widget.article.url,
                                  urlToImage: widget.article.urlToImage,
                                  publishedAt: widget.article.publishedAt,
                                  bookmarked: true));
                              newsS.saveBookmarkToLocal();
                            }
                          }
                        },
                        icon: _bookmarked
                            ? const Icon(
                                Icons.star,
                                color: Colors.yellow,
                              )
                            : const Icon(Icons.star_border))
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
      ),
    );
  }
}
