

class Source{
  String? id;
  String source;

  Source({required this.id,required this.source});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json["id"] ?? "", source: json["name"]);

  }

}