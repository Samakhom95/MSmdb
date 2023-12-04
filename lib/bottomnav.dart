import 'package:flutter/material.dart';
import 'package:movie_silver/src/actors.dart';
import 'package:movie_silver/src/home.dart';
import 'package:movie_silver/src/setting.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: menu(),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [HomeScreen(), ActorsScreen(), SettingScreen()],
        ),
      ),
    );
  }
}

Widget menu() {
  return Container(
    height: 60,
    color: Colors.transparent,
    child: const TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.transparent,
      tabs: [
        Tab(
          text: "Movies",
          icon: Icon(Icons.movie_creation_outlined),
        ),
        Tab(
          text: "Actors",
          icon: Icon(Icons.person_2_rounded),
        ),
        Tab(
          text: "Setting",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
}
