import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imversion/Screens/bookmark.dart';
import 'package:imversion/Screens/custom_news_container.dart';
import 'package:imversion/controller/newsServices.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../models/article_model.dart';
import '../widget/alertDialog.dart';


enum FilteredOptions { search,bookmark}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  final newsService = Get.put(NewsService());
  int currentIndex = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController searchText = TextEditingController();
  final List<String> _sortList = [
    "popularity",
    "relevancy",
  ];


  fetchSaved()async{
    await newsService.fetchSavedData();
  }
  getConnectivity() => subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected && isAlertSet == false) {
      print("no internet");
      MyAlertDialogue().openAlertBox(
          context: context,
          height: 30,
          width: double.infinity,
          body: Column(
            children: [
              const Text("Check Internet Connection!"),
              MaterialButton(
                onPressed: () {},
                child: const Text("Ok"),
              )
            ],
          ));
      setState(() {
        isAlertSet = true;
      });
    }
  });


  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    fetchSaved();getConnectivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffDEF5E5),
        appBar: AppBar(
          title: const Text("News"),
          backgroundColor: const Color(0xff8EC3B0),
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.green,
              ),
              onSelected: (FilteredOptions selectedOption) {
                if (selectedOption == FilteredOptions.search) {
                  MyAlertDialogue().openAlertBox(
                      context: context,
                      height: size.height * 0.4,
                      width: size.width,
                      body: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text("Search"),
                            TextFormField(
                              controller: searchText,
                              decoration: const InputDecoration(labelText: "Search"),
                            ),
                            const SizedBox(height: 20,),
                            const Text("Sort"),
                            Wrap(
                              children: _sortList.asMap().entries.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ActionChip(
                                    label: Text(e.value),
                                    onPressed: () {
                                      newsService.sortText.value = e.value.trim();
                                    },
                                  )
                                );
                              }).toList(),
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  newsService.searchText.value =
                                      searchText.text.trim();
                                  searchText.clear();
                                  Get.back();
                                }
                              },
                              color: const Color(0xff8EC3B0),
                              child: const Text("Search"),
                            )
                          ],
                        ),
                      ));
                }
                if(selectedOption == FilteredOptions.bookmark){
                  Get.to(()=>BookmarkScreen());
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: FilteredOptions.search,
                  child: Text('Search'),
                ),
                const PopupMenuItem(
                  value: FilteredOptions.bookmark,
                  child: Text('Bookmark'),
                ),
              ],
            ),
          ],
        ),
        body: FutureBuilder(
            future: newsService.newsData(),
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

// _isLoading
// ? Center(
// child: CircularProgressIndicator(),
// )
// : Container(
// height: size.height,
// width: size.width,
// child: ListView.builder(
// itemCount: articleService.allNews.length,
// itemBuilder: (ctx, i) {
// return CustomNewContainer(
// article: articleService.allNews[i],
// );
// }),
// ),
