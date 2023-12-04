// ignore_for_file: non_constant_identifier_names

class ActorsList {
  List<Actors>? actors;

  ActorsList({
    this.actors,
  });

  ActorsList.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      actors = [];
      json['results'].forEach((v) {
        actors!.add(Actors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (actors != null) {
      data['results'] = actors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actors {
  String? name;
  double? popularity;
  String? profile_path;
  String? known_for_department;
  int? id;

  Actors({this.name, this.popularity, this.profile_path, this.id});

  Actors.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    profile_path = json['profile_path'];
    popularity = json['popularity'];
    known_for_department = json['known_for_department'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['profile_path'] = profile_path;
    data['known_for_department'] = known_for_department;
    data['popularity'] = popularity;

    return data;
  }
}
