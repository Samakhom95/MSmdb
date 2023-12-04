import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_silver/model/actors.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/model/movie.dart';
import 'package:movie_silver/src/actors_detail.dart';
import 'package:movie_silver/src/genremovies.dart';
import 'package:movie_silver/src/movies.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ScrollingMovies extends StatefulWidget {
  final String? api, title;
  final List<Genres> genres;
  const ScrollingMovies(
      {super.key, this.api, this.title, required this.genres});
  @override
  // ignore: library_private_types_in_public_api
  _ScrollingMoviesState createState() => _ScrollingMoviesState();
}

class _ScrollingMoviesState extends State<ScrollingMovies> {
  List<Movie>? moviesList;
  @override
  void initState() {
    super.initState();
    fetchMovies(widget.api!).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.title!,
                style: GoogleFonts.oswald(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: moviesList == null
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: 200,
                                width: 300,
                                child: Image.asset(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    'assets/images/5.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: moviesList!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: MovieDetailPage(
                                    movie: moviesList![index],
                                    genres: widget.genres,
                                  )));
                        },
                        child: SizedBox(
                          width: 100,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.cover,
                                    '${TMDB_BASE_IMAGE_URL}w500/${moviesList![index].posterPath!}',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(moviesList![index].releaseDate!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11)),
                              ),
                              Text(moviesList![index].title!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class GenreList extends StatefulWidget {
  final List<int> genres;
  final List<Genres> totalGenres;
  const GenreList({super.key, required this.genres, required this.totalGenres});

  @override
  // ignore: library_private_types_in_public_api
  _GenreListState createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  List<Genres>? _genres;
  @override
  void initState() {
    super.initState();
    _genres = [];
    Future.delayed(Duration.zero, () {
      for (var valueGenre in widget.totalGenres) {
        for (var genre in widget.genres) {
          if (valueGenre.id == genre) {
            _genres?.add(valueGenre);
            setState(() {});
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 40,
        child: _genres == null
            ? const SpinKitWave(
                color: Colors.white,
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _genres!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: GenreMovies(
                                  genre: _genres![index],
                                  genres: widget.totalGenres,
                                )));
                      },
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        label: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            _genres![index].name!,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ));
  }
}

class PopularActors extends StatefulWidget {
  final String? api;
  const PopularActors({super.key, this.api});
  @override
  // ignore: library_private_types_in_public_api
  _PopularActorsState createState() => _PopularActorsState();
}

class _PopularActorsState extends State<PopularActors> {
  List<Actors>? actorsList;

  @override
  void initState() {
    super.initState();
    fetchActors(widget.api!).then((value) {
      setState(() {
        actorsList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: actorsList == null
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    width: 300,
                    child: Image.asset(
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        'assets/images/6.png'),
                  ),
                );
              },
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: actorsList!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ActorsDetailPage(
                                actorId: actorsList![index].id!,
                              )));
                    },
                    child: Hero(
                      tag: '${actorsList![index]}',
                      child: SizedBox(
                        width: 100,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  '${TMDB_BASE_IMAGE_URL}w500/${actorsList![index].profile_path!}',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                actorsList![index].name!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class GridViewMovies extends StatefulWidget {
  const GridViewMovies({
    super.key,
  });
  @override
  // ignore: library_private_types_in_public_api
  _GridViewMoviesState createState() => _GridViewMoviesState();
}

class _GridViewMoviesState extends State<GridViewMovies> {
  List<Movie>? moviesList;
  List<Genres> _genres = [];
  final random = Random();

  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
    fetchMovies(Endpoints.upcomingMoviesUrl(random.nextInt(2) + 1))
        .then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return moviesList == null
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 400, crossAxisCount: 2),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 100,
                child: Image.asset(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    'assets/images/5.png'),
              );
            },
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 400, crossAxisCount: 2),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: moviesList!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: MovieDetailPage(
                              movie: moviesList![index],
                              genres: _genres,
                            )));
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          '${TMDB_BASE_IMAGE_URL}w500/${moviesList![index].posterPath!}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          moviesList![index].releaseDate!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          moviesList![index].title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GenreList(
                        genres: moviesList![index].genreIds ?? [],
                        totalGenres: _genres,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

class GridViewMovies1 extends StatefulWidget {
  const GridViewMovies1({
    super.key,
  });
  @override
  // ignore: library_private_types_in_public_api
  _GridViewMovies1State createState() => _GridViewMovies1State();
}

class _GridViewMovies1State extends State<GridViewMovies1> {
  List<Genres> _genres = [];
  final random = Random();
  List<Movie>? nowPlaying;

  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
    fetchMovies(Endpoints.nowPlayingMoviesUrl(1)).then((value) {
      setState(() {
        nowPlaying = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return nowPlaying == null
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 400, crossAxisCount: 2),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 100,
                  child: Image.asset(
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      'assets/images/5.png'),
                ),
              );
            },
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 400, crossAxisCount: 2),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: nowPlaying!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: MovieDetailPage(
                              movie: nowPlaying![index],
                              genres: _genres,
                            )));
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          '${TMDB_BASE_IMAGE_URL}w500/${nowPlaying![index].posterPath!}',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          nowPlaying![index].releaseDate!,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          nowPlaying![index].title!,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GenreList(
                        genres: nowPlaying![index].genreIds ?? [],
                        totalGenres: _genres,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
