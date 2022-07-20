import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myplayer/helpers/enums.dart';
import 'package:path_provider/path_provider.dart';

import '../models/song.dart';

class MusicProvider extends ChangeNotifier{
  List<Song> _audiomackSongs = [];
  GetMusicState _getMusicState  = GetMusicState.idle;

  List<Song> get audiomackSongs => _audiomackSongs;
  GetMusicState get  getMusicState => _getMusicState;



  Future<String> _songDirectory() async {
    final Directory? directory = await getExternalStorageDirectory();
    directory!.createSync();
    log(directory.path);
    return directory.path;
  }
  Future<String> _tempDir() async {
    final Directory directory = await getTemporaryDirectory();
    return directory.path;
  }
  Future<void> getAudiomackSongs() async {
    _getMusicState = GetMusicState.loading;
    notifyListeners();
    List<FileSystemEntity> songs = [];
    List<FileSystemEntity> image = [];
    AudioPlayer audioPlayer = AudioPlayer();
    String songDirectory = await _songDirectory().then((value) {
      return value;
    });

    if (Directory(songDirectory).listSync().isEmpty) {
      updateAudiomackSongs();
    } else {
      try {
        songs = Directory(songDirectory).listSync(followLinks: false);
        image = Directory(
            '/storage/emulated/0/Download/com.audiomack/files/Audiomack/artworks')
            .listSync(followLinks: false);

        log(image.length.toString());
        for (int i = 0; i <= songs.length; i++) {
          File songPath = File(songs[i].path);
          File imagePath = File(image[i].path);
          final duration = Duration();

          if (songPath.path !=
              '/storage/emulated/0/Download/com.audiomack/files/Audiomack/artworks' &&
              songPath.path != '.nomedia') {
            log(songDirectory);
            // FileSystemEntity copiedSong = await  songPath.copySync('$songDirectory/$i.mp3');

            audiomackSongs.add(Song.fromMap({"name": songPath, "image": imagePath,"duration":duration}));
            log(' ALL ${{"song": songPath.path, "image": imagePath}}');
          } else {}
        }
      } catch (e) {
        log(e.toString());
        _getMusicState = GetMusicState.failure;
        notifyListeners();
      }
    }
    _getMusicState = GetMusicState.success;
    notifyListeners();
  }
  Future<void> updateAudiomackSongs() async {
    List<FileSystemEntity> songs = [];
    List<FileSystemEntity> image = [];
    String songDirectory = await _songDirectory().then((value) {
      return value;
    });
    try {
      songs = Directory(
          '/storage/emulated/0/Download/com.audiomack/files/Audiomack')
          .listSync(followLinks: false);
      image = Directory(
          '/storage/emulated/0/Download/com.audiomack/files/Audiomack/artworks')
          .listSync(followLinks: false);

      log(image.length.toString());
      for (int i = 0; i <= songs.length; i++) {
        File songPath = File(songs[i].path);
        File imagePath = File(image[i].path);

        if (songPath.path !=
            '/storage/emulated/0/Download/com.audiomack/files/Audiomack/artworks' &&
            songPath.path != '.nomedia') {
          log(songDirectory);
          FileSystemEntity copiedSong =
          await songPath.copySync('$songDirectory/$i.mp3');
          audiomackSongs.add(Song.fromMap({"C": songPath, "image": imagePath,"duration":const Duration()}));
          // audiomackSongs.add({"song": copiedSong, "image": imagePath});
          log(' ALL ${{"song": copiedSong.path, "image": imagePath}}');
        } else {}
      }
    } catch (e) {
      log(e.toString());
      _getMusicState = GetMusicState.failure;
      notifyListeners();
    }
    _getMusicState = GetMusicState.success;
    notifyListeners();
  }

}