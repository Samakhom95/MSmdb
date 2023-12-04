import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:movie_silver/model/credits.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/model/moviestrailer.dart';
import 'package:movie_silver/secSrc/fullimage.dart';
import 'package:movie_silver/secSrc/playvid.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/actors_detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviesDetails extends StatefulWidget {
  final int id;
  final List<Genres> genres;
  const MoviesDetails({super.key, required this.id, required this.genres});

  @override
  State<MoviesDetails> createState() => _MoviesDetailsState();
}

class _MoviesDetailsState extends State<MoviesDetails> {
  Credits? credits;
  List<Trailer>? moviesTrailer;
  final ValueNotifier<String> stringNotifier = ValueNotifier('Yes');
  void _stringNotifier() => stringNotifier.value = '';
  void _stringNotifier1() => stringNotifier.value = 'Yes';

  @override
  void initState() {
    super.initState();
    fetchMovieImages();
    fetchSimilarMovies();
    _fetchMovieDetails();
    fetchCredits(Endpoints.getCreditsUrl(widget.id)).then((value) {
      setState(() {
        credits = value;
      });
    });
    fetchMoviesTrailer(Endpoints.moviesTrailer(widget.id)).then((value) {
      setState(() {
        moviesTrailer = value;
      });
    });
  }

  List<String> imageUrls = [];
  List<String> reccomTitleUrl = [];
  List<String> reccomPosterUrl = [];
  List<double> reccomIds = [];
  Map<String, dynamic>? movieDetails;

  Future<void> _fetchMovieDetails() async {
    const String apiKey = '91da303c9cc4cea1a33482ca684c4f20';
    final String baseUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}';
    final String url = '$baseUrl?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        movieDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<void> fetchMovieImages() async {
    const apiKey = '91da303c9cc4cea1a33482ca684c4f20';
    final baseUrl = 'https://api.themoviedb.org/3/movie/${widget.id}/images';

    final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        imageUrls = List<String>.from(data["backdrops"].map((poster) =>
            'https://image.tmdb.org/t/p/w500/${poster["file_path"]}'));
      });
    } else {
      // Handle error
    }
  }

  Future<void> fetchSimilarMovies() async {
    const apiKey = '91da303c9cc4cea1a33482ca684c4f20';
    final baseUrl =
        'https://api.themoviedb.org/3/movie/${widget.id}/recommendations';

    final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        reccomPosterUrl = List<String>.from(data["results"].map((poster) =>
            'https://image.tmdb.org/t/p/w500/${poster["poster_path"]}'));
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: moviesTrailer == null
          ? ''
          : moviesTrailer!.isEmpty
              ? ''
              : moviesTrailer![0].key!,
      flags: const YoutubePlayerFlags(
        disableDragSeek: true,
        showLiveFullscreenButton: false,
        autoPlay: false,
        mute: false,
      ),
    );
    return Scaffold(
      body: movieDetails == null
?Container()
:ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              movieDetails!['backdrop_path'] == null
                  ? Container()
                  : ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.network(
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        '${TMDB_BASE_IMAGE_URL}original/${movieDetails!['backdrop_path']}',
                      ),
                    ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: movieDetails!['poster_path'] == null
                      ? Image.asset(
                          'assets/images/4.png',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          '${TMDB_BASE_IMAGE_URL}w500/${movieDetails!['poster_path']}',
                        ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      movieDetails!['original_title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(movieDetails!['vote_average'].toString().substring(0,3)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Release date : ${movieDetails!['release_date']}',
                  ),
                ],
              ),
            ],
          ),
       /*    const SizedBox(
            height: 10,
          ),
          widget.genres.isEmpty
              ? Container()
              : GenreList(
                  genres: widget.movie.genreIds ?? [],
                  totalGenres: widget.genres,
                ), */
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  moviesTrailer == null
                      ? ''
                      : moviesTrailer!.isEmpty
                          ? ''
                          : moviesTrailer![0].type!,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          moviesTrailer == null
              ? Container()
              : moviesTrailer!.isEmpty
                  ? Container()
                  : YoutubePlayer(
                      controller: controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.grey,
                    ),
          const SizedBox(
            height: 15,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('Browse '),
              ),
            ],
          ),
          moviesTrailer == null
              ? Container()
              : moviesTrailer!.isEmpty
                  ? Container()
                  : SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: moviesTrailer!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final YoutubePlayerController controller1 =
                              YoutubePlayerController(
                            initialVideoId: moviesTrailer![index].key!,
                            flags: const YoutubePlayerFlags(
                              disableDragSeek: true,
                              autoPlay: false,
                              hideControls: true,
                            ),
                          );
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white60, width: 2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: PlayVideoScreen(
                                                  url: moviesTrailer![index]
                                                      .key!,
                                                )),
                                          ),
                                          child: YoutubePlayer(
                                            controller: controller1,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.play_arrow,
                                          size: 35,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      width: 240,
                                      child: Center(
                                        child: Text(
                                          moviesTrailer![index].name!,
                                          maxLines: 2,
                                        ),
                                      )),
                                  Text(
                                    '(${moviesTrailer![index].type})',
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('Gallery '),
              ),
              Text('(${imageUrls.length.toString()})'),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: imageUrls.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () => Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: FullImageScreen(
                                  imgUrl: imageUrls[index],
                                )),
                          ),
                      child: Image.network(imageUrls[index])),
                );
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Overview',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              movieDetails!['overview']
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          reccomPosterUrl.isEmpty
              ? Container()
              : Column(
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text(
                            'More like this',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: reccomPosterUrl.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () => {},
                                child: Image.network(reccomPosterUrl[index])),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
          ValueListenableBuilder<String>(
              valueListenable: stringNotifier,
              builder: (context, value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          value == '' ? _stringNotifier1() : _stringNotifier(),
                      child: Text('Cast',
                          style: TextStyle(
                              decoration: value == ''
                                  ? TextDecoration.none
                                  : TextDecoration.underline,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    GestureDetector(
                      onTap: () =>
                          value == '' ? _stringNotifier1() : _stringNotifier(),
                      child: Text('Crew',
                          style: TextStyle(
                              decoration: value == ''
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
              }),
          ValueListenableBuilder<String>(
              valueListenable: stringNotifier,
              builder: (context, value, child) {
                return value == '' ? crewList() : castList();
              }),
        ],
      ),
    );
  }

  Widget crewList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        credits == null
            ? const Center(
                child: SpinKitWave(
                  color: Colors.white,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: credits?.crew?.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 100,
                    height: 190,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 140,
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: credits!.crew![index].profilePath == null
                                  ? const SizedBox(
                                      width: 120,
                                      height: 150,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: ActorsDetailPage(
                                                  actorId:
                                                      credits!.crew![index].id!,
                                                )));
                                      },
                                      child: Image.network(
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover,
                                        '${TMDB_BASE_IMAGE_URL}w500/${credits!.crew![index].profilePath!}',
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                credits!.crew![index].name!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('as: ${credits!.crew![index].job!}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12)),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget castList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        credits == null
            ? const Center(
                child: SpinKitWave(
                  color: Colors.white,
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: credits?.cast!.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 100,
                    height: 190,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 140,
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: credits!.cast![index].profilePath == null
                                  ? Image.asset(
                                      'assets/images/3.png',
                                      fit: BoxFit.cover,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: ActorsDetailPage(
                                                  actorId:
                                                      credits!.cast![index].id!,
                                                )));
                                      },
                                      child: Image.network(
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover,
                                        '${TMDB_BASE_IMAGE_URL}w500/${credits!.cast![index].profilePath!}',
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 200,
                                child: Text(
                                  credits!.cast![index].name!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 200,
                                child: Text(
                                    'as: ${credits!.cast![index].character!}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }
}
