// ignore_for_file: non_constant_identifier_names

class ActorDetail {
     int? page;
  int? totalMovies;
  int? totalPages;
  List<Detail>? detail;

  ActorDetail({
    this.detail,
  });

  ActorDetail.fromJson(Map<String, dynamic> json) {
     page = json['page'];
    totalMovies = json['total_results'];
    totalPages = json['total_pages'];

    detail = [];
    detail!.add(Detail.fromJson(json));
    /* if (json[''] != null) {
       detail = [];
      json[''].forEach((v) {
        detail!.add(Detail.fromJson(v));
      }); 
    } */
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['total_results'] = totalMovies;
    data['total_pages'] = totalPages;

    detail!.map((v) => v.toJson()).toList();
    /* if (this.detail != null) {
    this.detail!.map((v) => v.toJson()).toList();
     
    } */
    return data;
  }
}

class Detail {
  //bool? adult;
  //List<String> also_known_as;
  String? biography;
  //String? birthday;
  //String? deathday;
  //double? gender;
  //String? homepage;
  int? id;
  //String? imdb_id;
  //String? known_for_department;
  String? name;
  //String? place_of_birth;
  //double? popularity;
  String? profile_path;

  Detail(
      {this.name,
      //this.popularity,
      this.profile_path,
      this.id,
      //this.adult,
      //required this.also_known_as,
      this.biography,
      //this.birthday,
      //this.deathday,
      //this.gender,
      //this.homepage,
      //this.imdb_id,
      //this.known_for_department,
      //this.place_of_birth
      });

  Detail.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    profile_path = json['profile_path'];
    biography = json['biography'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['profile_path'] = profile_path;
    data['biography'] = biography;

    return data;
  }
}
