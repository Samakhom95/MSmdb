import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_silver/model/actormovie.dart';
import 'package:movie_silver/model/actorseries.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/secSrc/allmovies.dart';
import 'package:movie_silver/secSrc/allseries.dart';
import 'package:movie_silver/secSrc/fullimage.dart';
import 'package:movie_silver/services/api_constants.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/services/function.dart';
import 'package:movie_silver/src/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ActorsDetailPage extends StatefulWidget {
  final int actorId;
  const ActorsDetailPage({
    super.key,
    required this.actorId,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ActorsDetailPageState createState() => _ActorsDetailPageState();
}

class _ActorsDetailPageState extends State<ActorsDetailPage> {
  String apiKey = '91da303c9cc4cea1a33482ca684c4f20';
  List<ActorsMovies>? actorMoviesList;
  List<ActorsSeries>? actorSeriesList;
  List<Genres> _genres = [];
  String loading = '';
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchActorImages();
    getPersonDetails1(widget.actorId);
    getPersonMedia(widget.actorId);
    fetchGenres().then((value) {
      _genres = value.genres ?? [];
    });
    fetchActorMovies(Endpoints.actorsMovies(widget.actorId)).then((value) {
      setState(() {
        actorMoviesList = value;
      });
    });
    fetchActorSeries(Endpoints.actorsSeries(widget.actorId)).then((value) {
      setState(() {
        actorSeriesList = value;
      });
    });
  }

  Map<String, dynamic>? actorDetails;
  Future<void> getPersonDetails1(int personId) async {
    final String baseUrl = 'https://api.themoviedb.org/3/person/$personId';
    final String url = '$baseUrl?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        actorDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load person details');
    }
  }

  Future<void> fetchActorImages() async {
    const apiKey = '91da303c9cc4cea1a33482ca684c4f20';
    final baseUrl =
        'https://api.themoviedb.org/3/person/${widget.actorId}/images';

    final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        imageUrls = List<String>.from(data["profiles"].map((poster) =>
            'https://image.tmdb.org/t/p/w500/${poster["file_path"]}'));
      });
    } else {
      // Handle error
    }
  }

Map<String, dynamic>? personMedia;
  Future<void> getPersonMedia(int personId) async {
    final String baseUrl =
        'https://api.themoviedb.org/3/person/$personId/external_ids';
    final String url = '$baseUrl?api_key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        personMedia = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load person details');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime birthdate = DateTime.parse(actorDetails!['birthday']);
    DateTime currentDate = DateTime.now();
    int age1 = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age1--;
    }
      final igUrl =
                            'https://www.instagram.com/${personMedia!['instagram_id']}';
                        final fbUrl =
                            'https://www.facebook.com/${personMedia!['facebook_id']}';
                        final xUrl =
                            'https://www.twitter.com/${personMedia!['twitter_id']}';
    return Scaffold(
      body: actorDetails == null
          ? Container()
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: 100,
                      height: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: actorDetails!['profile_path'] == null
                            ? Image.asset(
                                'assets/images/3.png',
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                fit: BoxFit.cover,
                                '${TMDB_BASE_IMAGE_URL}w500/${actorDetails!['profile_path']}',
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SizedBox(
                        width: 230,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${actorDetails!['name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Birthday: ${actorDetails!['birthday']}'),
                            Text(
                                'Place of Birth: ${actorDetails!['place_of_birth']}'),
                            Text('age: $age1'),
                            Text(
                                'known for: ${actorDetails!['known_for_department']}'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              igUrl == 'null'
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () async {
                                        await launchUrlString(igUrl);
                                      },
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                                'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/2048px-Instagram_logo_2016.svg.png')),
                                      ),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              fbUrl == 'null'
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () async {
                                        await launchUrlString(fbUrl);
                                      },
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                                'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/1200px-Facebook_Logo_%282019%29.png')),
                                      ),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              xUrl == 'null'
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () async {
                                        await launchUrlString(xUrl);
                                      },
                                      child: SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                                'https://upload.wikimedia.org/wikipedia/commons/9/95/Twitter_new_X_logo.png')),
                                      ),
                                    ),
                            ],
                          )),
                      
                      
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${actorDetails!['biography']}'),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Gallery ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '(${imageUrls.length.toString()})',
                          style: const TextStyle(
                            color: Colors.grey,
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
                  ],
                ),
                Row(
                  children: [
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: AllMoviesScreen(
                                actorId: widget.actorId,
                                name: actorDetails!['name'],
                              )),
                        ),
                        child: const Text(
                          'see all',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                actorMoviesList == null
                    ? const Center(
                        child: SpinKitWave(
                          color: Colors.white,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: actorMoviesList?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: 100,
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    actorMoviesList![index].posterPath == null
                                        ? Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                filterQuality:
                                                    FilterQuality.high,
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
                                          actorMoviesList![index].genreIds ??
                                              [],
                                      totalGenres: _genres,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Row(
                  children: [
                    const Text(
                      'Series',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '(${actorSeriesList!.length.toString()})',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: AllSeriesScreen(
                                actorId: widget.actorId,
                                name: actorDetails!['name'],
                              )),
                        ),
                        child: const Text(
                          'see all',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                actorSeriesList == null
                    ? const Center(
                        child: SpinKitWave(
                          color: Colors.white,
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: actorSeriesList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: 100,
                                height: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    actorSeriesList![index].posterPath == null
                                        ? Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.asset(
                                                filterQuality:
                                                    FilterQuality.high,
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
                                                '${TMDB_BASE_IMAGE_URL}w500/${actorSeriesList![index].posterPath!}',
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        actorSeriesList![index].name!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GenreList(
                                      genres:
                                          actorSeriesList![index].genreIds ??
                                              [],
                                      totalGenres: _genres,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
    );
  }
}
