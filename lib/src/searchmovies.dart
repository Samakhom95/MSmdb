import 'package:flutter/material.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/model/movie.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/movies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Genres> _genres = [];
  List<Movie>? moviesList;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextFormField(
            focusNode: _focusNode,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 2.0),
              ),
              errorStyle: const TextStyle(color: Colors.grey),
              hintText: 'search movie',
              filled: false,
              fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                 fetchMovies(Endpoints.movieSearchUrl(value)).then((value) {
      setState(() {
        moviesList = value;
      });
    });
              });
            },
          ),
        ),
        body: moviesList == null
            ? Container()
            : moviesList!.isEmpty
                ? const Center(
                    child: Text(
                      "Oops! couldn't find the movie",
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: moviesList!.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MovieDetailPage(
                                                movie: moviesList![index],
                                                genres: _genres,
                                              )));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      height: 180,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: moviesList![index].posterPath ==
                                                null
                                            ? Image.asset(
                                                'assets/images/4.png',
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                filterQuality:
                                                    FilterQuality.high,
                                                fit: BoxFit.cover,
                                                '${TMDB_BASE_IMAGE_URL}w500/${moviesList![index].posterPath!}',
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              moviesList![index].title!,
                                              
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              moviesList![index].overview!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  size: 14,
                                                  color: Colors.amber),
                                              Text(
                                                moviesList![index]
                                                    .voteAverage!
                                                    .substring(0, 3),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ));
  }
}
