// ignore_for_file: non_constant_identifier_names

class MoviesTrailer {
  List<Trailer>? trailer;

  MoviesTrailer({
    this.trailer,
  });

  MoviesTrailer.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      trailer = [];
      json['results'].forEach((v) {
        trailer!.add(Trailer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trailer != null) {
      data['results'] = trailer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trailer {
  String? name;
  String? key;
  String? site;
  String? type;

  Trailer({this.name, this.type, this.key, this.site});

  Trailer.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    key = json['key'];
    site = json['site'];
    type = json['type'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['key'] = key;
    data['site'] = site;
    data['type'] = type;


    return data;
  }
}
