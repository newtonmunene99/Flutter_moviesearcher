import 'package:flutter/material.dart';
import 'package:moviesearcher/screens/home.dart';
import 'package:moviesearcher/screens/favorites.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Movie Searcher",
      theme: ThemeData.dark(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Movie Searcher App"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home Page',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: "Favorites",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              HomePage(),
              Favorites(),
            ],
          ),
        ),
      ),
    );
  }
}
