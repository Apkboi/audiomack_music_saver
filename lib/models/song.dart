import 'dart:io';
import 'dart:convert';

Song songFromMap(String str) => Song.fromMap(json.decode(str));

String songToMap(Song data) => json.encode(data.toMap());

class Song {
  Song({
    this.name,
    this.image,
    this.duration,
  });

  File? name;
  File? image;
  Duration? duration;

  factory Song.fromMap(Map<String, dynamic> json) => Song(
    name: json["name"],
    image: json["image"],
    duration: json["duration"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "image": image,
    "duration": duration,
  };
}