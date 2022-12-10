
import 'package:flutter/material.dart';
import 'package:imversion/Screens/Home.dart';
import 'package:imversion/Screens/source_screen.dart';
import 'package:imversion/Screens/top_headline_screen.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


  int currentIndex = 0;

  List<Widget> screens = [Home(), const TopHeadLineScreen(), SourceScreen()];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_sharp), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.feed), label: "Top Headline"),
          BottomNavigationBarItem(icon: Icon(Icons.source), label: "Source"),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
