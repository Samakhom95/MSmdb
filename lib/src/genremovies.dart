import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_silver/model/movie.dart';
import 'package:movie_silver/model/moviestrailer.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/movies.dart';
import 'package:page_transition/page_transition.dart';

class GenreMovies extends StatefulWidget {
  final Genres genre;
  final List<Genres> genres;

  const GenreMovies(
      {super.key, required this.genre, required this.genres});

  @override
  State<GenreMovies> createState() => _GenreMoviesState();
}

class _GenreMoviesState extends State<GenreMovies> {
     List<Movie>? moviesList;
     List<MoviesTrailer>? moviesTrailer;
     final random = Random();
     
  @override
  void initState() {
    super.initState();
    fetchMovies(Endpoints.getMoviesForGenre(widget.genre.id!, random.nextInt(50) + 1)).then((value) {
      setState(() {
        moviesList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[850],
        title: Text(
          widget.genre.name!,
        ),
      ),
      body: Container(
      child: moviesList == null
          ? const Center(
              child: SpinKitWave(
              color: Colors.white,
            ),
            )
          : ListView.builder(
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
                                child:  MovieDetailPage(
                                  movie: moviesList![index],
                                  genres: widget.genres, 
                                )));
             
                    },
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Row(
                        children: [
                           Hero(
                            tag: '${moviesList![index].id}',
                            child: SizedBox(
                              width: 120,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                  '${TMDB_BASE_IMAGE_URL}w500/${moviesList![index].posterPath!}',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    moviesList![index].title!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                   SizedBox(
                                    width: 200,
                                     child: Text(
                                            moviesList![index].overview!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,style: const TextStyle(fontSize: 12),
                                          ),
                                   ),
                                const SizedBox(height: 5,),

                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 13,
                                    ),
                                    Text(
                                      moviesList![index].voteAverage!,
                                       style: const TextStyle(fontSize: 13),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                         
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    )
    );
  }
}
