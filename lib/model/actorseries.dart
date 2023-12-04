// ignore_for_file: non_constant_identifier_names

class ActorSeriesList {
   int? page;
  int? totalMovies;
  int? totalPages;
  List<ActorsSeries>? actorSeries;

  ActorSeriesList({this.actorSeries,this.page, this.totalMovies, this.totalPages,});

  ActorSeriesList.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalMovies = json['total_results'];
    totalPages = json['total_pages'];
    if (json['cast'] != null) {
      actorSeries = [];
      json['cast'].forEach((v) {
        actorSeries!.add(ActorsSeries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
     data['page'] = page;
    data['total_results'] = totalMovies;
    data['total_pages'] = totalPages;
    if (actorSeries != null) {
      data['cast'] = actorSeries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActorsSeries {
  int? voteCount;
  int? id;
  String? voteAverage;
  String? name;
  double? popularity;
  String? posterPath;
  String? originalLanguage;
  String? original_name;
  List<int>? genreIds;
  String? backdropPath;
  bool? adult;
  String? overview;
  String? first_air_date;

  ActorsSeries(
      {this.voteCount,
      this.id,
      this.voteAverage,
      this.name,
      this.popularity,
      this.posterPath,
      this.originalLanguage,
      this.original_name,
      this.genreIds,
      this.backdropPath,
      this.adult,
      this.overview,
      this.first_air_date});


  ActorsSeries.fromJson(Map<String, dynamic> json) {
    voteCount = json['vote_count'];
    id = json['id'];
    voteAverage = json['vote_average'].toString();
    name = json['name'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    originalLanguage = json['original_language'];
    original_name = json['original_name'];
    genreIds = json['genre_ids'].cast<int>();
    backdropPath = json['backdrop_path'];
    adult = json['adult'];
    overview = json['overview'];
    first_air_date = json['first_air_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vote_count'] = voteCount;
    data['id'] = id;
    data['vote_average'] = voteAverage;
    data['name'] = name;
    data['popularity'] = popularity;
    data['poster_path'] = posterPath;
    data['original_language'] = originalLanguage;
    data['original_name'] = original_name;
    data['genre_ids'] = genreIds;
    data['backdrop_path'] = backdropPath;
    data['adult'] = adult;
    data['overview'] = overview;
    data['first_air_date'] = first_air_date;
    return data;
  }
}
