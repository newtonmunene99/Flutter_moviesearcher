import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:moviesearcher/models/model.dart';
import 'package:moviesearcher/database/database.dart';

class Favorites extends StatefulWidget {
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Movie> filteredMovies = List();
  List<Movie> movieCache = List();

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    filteredMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    setUpList();
  }

  void setUpList() async {
    MovieDatabase db = MovieDatabase();
    filteredMovies = await db.getMovies();
    setState(() {
      movieCache = filteredMovies;
    });
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  void searchDataList(query) {
    if (query.isEmpty) {
      setState(() {
        filteredMovies = movieCache;
      });
    } else {
      setState(() {});
      filteredMovies = filteredMovies
          .where((m) => m.title
              .toLowerCase()
              .trim()
              .contains(RegExp(r'' + query.toLowerCase().trim() + '')))
          .toList();
      setState(() {});
    }
  }

  void onPressed(int index) {
    setState(() {
      filteredMovies.remove(filteredMovies[index]);
      MovieDatabase db = MovieDatabase();
      db.deleteMovie(filteredMovies[index].id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: filteredMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  initiallyExpanded: filteredMovies[index].isExpanded ?? false,
                  onExpansionChanged: (b) =>
                      filteredMovies[index].isExpanded = b,
                  children: <Widget>[],
                  leading: IconButton(
                    icon: Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      onPressed(index);
                    },
                  ),
                  title: Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        filteredMovies[index].posterPath != null
                            ? Hero(
                                child: Image.network(
                                    "https://image.tmdb.org/t/p/w92/${filteredMovies[index].posterPath}"),
                                tag: filteredMovies[index].id,
                              )
                            : Container(),
                        Expanded(
                          child: Text(
                            filteredMovies[index].title,
                            textAlign: TextAlign.center,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
