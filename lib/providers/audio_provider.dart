import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../models/song.dart';

class AudioProvider extends ChangeNotifier{

  final _audioPLayer = AudioPlayer();
   bool _isPlaying = false;
  final Duration _playerPosition = Duration.zero;
  final Duration _duration = Duration.zero;
  late AudioSource _playlist;

  bool get isPlaying  => _isPlaying;
  Duration get playerPosition  => _playerPosition;
  Duration get duration  => _duration;


  // AudioPlayer getInstance (){
  //   _audioPLayer.
  // }


  Future<void> init(List<Song> songs,) async {

    // final _player = AudioPlayer();
    // _audioPLayer.dispose();
    _playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: List.generate(
          songs.length,
              (index) => AudioSource.uri(
              Uri.parse('file://${songs[index].name!.path}',),
              tag: MediaItem(
                  id: index.toString(),
                  artUri: Uri.parse(
                      "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
                  title: songs[index].name!.path))),
    );
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    _audioPLayer.playbackEventStream.listen((event) {
      // event.p
    },
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });

    if(_audioPLayer.audioSource == null){
      try {
        // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
        _audioPLayer.setAudioSource(_playlist,initialIndex:0,);
        // _audioPLayer.play().then((value) {
        //
        // });
      } catch (e, stackTrace) {
        log("Error loading audio source: $e");
        log("Error loading audio source: $stackTrace");

      }
    }
    // Try to load audio from a source and catch any errors.
    listenToPlayState();

  }

  Future<void> playAudio (int index) async {
    if(_audioPLayer.playing){
      _audioPLayer.seek(Duration.zero,index: index);
    }else{
      // _audioPLayer.seek(Duration.zero,index:index);
      _audioPLayer.play();
      log('notPlaying');
    }
  }

  Future<void> pauseAudio() async {

    if(_audioPLayer.playing){
      _audioPLayer.pause();
    }
  }
  Future<void> stop() async {

    if(_audioPLayer.playing){

      _audioPLayer.stop();

      // _audioPLayer.dispose();
    }
  }
  Future<void> next() async {

    if(_audioPLayer.hasNext){

      _audioPLayer.seekToNext();

      // _audioPLayer.dispose();
    }else{
      _audioPLayer.seek(Duration.zero,index: 0);
    }
  }
  Future<void> previous() async {

    if(_audioPLayer.hasPrevious){

      _audioPLayer.seekToPrevious();

      // _audioPLayer.dispose();
    }else{
      _audioPLayer.seek(Duration.zero,index: 0);
    }
  }
  Future<void> dispose() async {

    if(_audioPLayer.playing){

      _audioPLayer.dispose();
      // _audioPLayer.dispose();
    }
  }

  Future<void> listenToPlayState () async {
    _audioPLayer.playerStateStream.listen((event,) {
      _isPlaying = event.playing;
      notifyListeners();

    },onError: (datEvent){});
    _audioPLayer.positionStream.listen((event) { });
    _audioPLayer.bufferedPositionStream.listen((event) { });
    _audioPLayer.durationStream.listen((event) { });
  }




  // Future<void> setAudioResource()async {
  //   // Try to load audio from a source and catch any errors.
  //   try {
  //     // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
  //     log(songs.length.toString());
  //     _audioPLayer.setAudioSource(_playlist,initialIndex: widget.index,);
  //   } catch (e, stackTrace) {
  //
  //     log("Error loading audio source: $e");
  //     log("Error loading audio source: $stackTrace");
  //
  //   }
  // }
}