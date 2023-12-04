
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/model/movie.dart';
import 'package:movie_silver/src/movies.dart';
import 'package:movie_silver/src/searchmovies.dart';
import 'package:movie_silver/src/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_silver/test/movies_detail.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Genres> _genres = [];
  List<Movie>? discover;
  int num = 0;

  final random = Random();

  @override
  void initState() {
    super.initState();
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
    fetchMovies(Endpoints.discoverMoviesUrl(random.nextInt(5) + 1))
        .then((value) {
      setState(() {
        discover = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [
          discover == null
              ? CarouselSlider.builder(
                  itemCount: 5,
                  options: CarouselOptions(viewportFraction: 1, height: 350),
                  itemBuilder:
                      (BuildContext context, int index, pageViewIndex) {
                    return ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: SizedBox(
                        height: 200,
                        width: 300,
                        child: Image.asset(
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                            'assets/images/5.png'),
                      ),
                    );
                  })
              : Stack(children: [
                  CarouselSlider.builder(
                      itemCount: 5,
                      options:
                          CarouselOptions(viewportFraction: 1, height: 350),
                      itemBuilder:
                          (BuildContext context, int index, pageViewIndex) {
                        return ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.black, Colors.transparent],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.dstIn,
                          child: SizedBox(
                            height: 500,
                            child: Image.network(
                              height: 500,
                              width: 800,
                              fit: BoxFit.cover,
                              '${TMDB_BASE_IMAGE_URL}original/${discover![num].backdropPath!}',
                            ),
                          ),
                        );
                      }),
                  discover == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: CarouselSlider.builder(
                              itemCount: 5,
                              options: CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                viewportFraction: 0.55,
                                enlargeCenterPage: true,
                                pageSnapping: true,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                autoPlayAnimationDuration:
                                    const Duration(seconds: 2),
                                onPageChanged: (index, value) {
                                  setState(() {
                                    num = index;
                                  });
                                },
                              ),
                              itemBuilder: (BuildContext context, int index,
                                  pageViewIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            child: MovieDetailPage(
                                              movie: discover![index],
                                              genres: _genres,
                                            )));
                                  },
                                  child: Hero(
                                    tag: '${discover![index].id}discover',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        width: 160,
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover,
                                        '${TMDB_BASE_IMAGE_URL}w500/${discover![index].posterPath!}',
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                  AppBar(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Row(
                      children: [
                        Image.asset(
                          'assets/images/1.png',
                          fit: BoxFit.cover,
                          height: 40,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'MSmdb',
                          style: GoogleFonts.bangers(fontSize: 20),
                        ),
                      ],
                    ),
                    centerTitle: true,
                    titleTextStyle: const TextStyle(
                      color: Colors.white70,
                    ),
                    actions: [
                       IconButton(
                          icon: const Icon(Icons.abc),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child:  const MoviesDetails(id: 346698, genres: [],)));
                          }),
                      IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const SearchScreen()));
                          })
                    ],
                  ),
                ]),
          ScrollingMovies(
            title: 'Top Rated',
            api: Endpoints.topRatedUrl(random.nextInt(5) + 1),
            genres: _genres,
          ),
          ScrollingMovies(
            title: 'Popular',
            api: Endpoints.popularMoviesUrl(random.nextInt(5) + 1),
            genres: _genres,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Now Playing',
                  style:
                      GoogleFonts.oswald(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ],
          ),
          const GridViewMovies1(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Upcoming Movies',
                  style:
                      GoogleFonts.oswald(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ],
          ),
          const GridViewMovies()
        ],
      ),
    );
  }
}
