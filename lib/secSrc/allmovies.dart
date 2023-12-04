import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_silver/model/actormovie.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/widgets.dart';

class AllMoviesScreen extends StatefulWidget {
  final int actorId;
  final String name;
  const AllMoviesScreen({super.key, required this.actorId, required this.name});

  @override
  State<AllMoviesScreen> createState() => _AllMoviesScreenState();
}

class _AllMoviesScreenState extends State<AllMoviesScreen> {
  List<ActorsMovies>? actorMoviesList;
  List<Genres> _genres = [];

  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
    fetchActorMovies(Endpoints.actorsMovies(widget.actorId)).then((value) {
      setState(() {
        actorMoviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: actorMoviesList ==null
      ?Container()
      :
      ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.name,
                  ),
                ),
                const Text(
                  'Movies',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '(${actorMoviesList!.length.toString()})',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actorMoviesList == null
                ? const Center(
                    child: SpinKitWave(
                      color: Colors.white,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: screenHeight,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: actorMoviesList?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: 100,
                            height: 260,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                actorMoviesList![index].posterPath == null
                                    ? Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                            'assets/images/4.png',
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            fit: BoxFit.cover,
                                            '${TMDB_BASE_IMAGE_URL}w500/${actorMoviesList![index].posterPath!}',
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    actorMoviesList![index].title!,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GenreList(
                                  genres:
                                      actorMoviesList![index].genreIds ?? [],
                                  totalGenres: _genres,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ]),
    );
  }
}
