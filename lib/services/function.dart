import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_silver/model/actormovie.dart';
import 'package:movie_silver/model/actors.dart';
import 'package:movie_silver/model/actorseries.dart';
import 'package:movie_silver/model/moviestrailer.dart';
import 'package:movie_silver/services/endpoints.dart';
import 'package:movie_silver/model/credits.dart';
import 'package:movie_silver/model/genres.dart';
import 'package:movie_silver/model/movie.dart';

Future<List<Movie>> fetchMovies(String api) async {
  MovieList movieList;
  var res = await http.get(Uri.parse(api));
  var decodeRes = jsonDecode(res.body);
  movieList = MovieList.fromJson(decodeRes);
  return movieList.movies ?? [];
}

Future<List<Trailer>> fetchMoviesTrailer(String api) async {
  MoviesTrailer trailer;
  var res = await http.get(Uri.parse(api));
  var decodeRes = jsonDecode(res.body);
  trailer = MoviesTrailer.fromJson(decodeRes);
  return trailer.trailer ?? [];
}

Future<List<ActorsMovies>> fetchActorMovies(String api) async {
  ActorsMoviesList actorMovies;
  var res = await http.get(Uri.parse(api));
  var decodeRes = jsonDecode(res.body);
  actorMovies = ActorsMoviesList.fromJson(decodeRes);
  return actorMovies.actorMovies ?? [];
}

Future<List<ActorsSeries>> fetchActorSeries(String api) async {
  ActorSeriesList actorSeries;
  var res = await http.get(Uri.parse(api));
  var decodeRes = jsonDecode(res.body);
  actorSeries = ActorSeriesList.fromJson(decodeRes);
  return actorSeries.actorSeries ?? [];
}


Future<List<Actors>> fetchActors(String api) async {
  ActorsList actorsList;
  var res = await http.get(Uri.parse(api));
  var decodeRes = jsonDecode(res.body);
  actorsList = ActorsList.fromJson(decodeRes);
  return actorsList.actors ?? [];
}

Future<Credits> fetchCredits(String api) async {
  Credits credits;
  var res = await http.get(Uri.parse(api));
  var decodeRes = jsonDecode(res.body);
  credits = Credits.fromJson(decodeRes);
  return credits;
}

Future<GenresList> fetchGenres() async {
  GenresList genresList;
  var res = await http.get(Uri.parse(Endpoints.genresUrl()));
  var decodeRes = jsonDecode(res.body);
  genresList = GenresList.fromJson(decodeRes);
  return genresList;
}
