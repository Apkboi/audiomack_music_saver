import 'dart:developer';
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:myplayer/providers/audio_provider.dart';
import 'package:myplayer/screens/views/home/widgets/download_button.dart';
import 'package:myplayer/screens/views/home/widgets/play_button.dart';
import 'package:myplayer/screens/views/home/widgets/save_music_modal.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../../models/song.dart';

class MusicPlayerScreen extends StatefulWidget {
  final List<Song> songs;
  final int index;

  const MusicPlayerScreen({Key? key, required this.songs, required this.index})
      : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  final _player = AudioPlayer();
  var currentRange = 0.0;
// Define the playlist
  late AudioSource playlist;

  Future<void> _init() async {
    // final _player = AudioPlayer();
    playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: List.generate(
          widget.songs.length,
          (index) => AudioSource.uri(
              Uri.parse(
                'file://${widget.songs[index].name!.path}',
              ),
              tag: MediaItem(
                  id: index.toString(),
                  artUri: Uri.parse(
                      "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
                  title: widget.songs[index].name!.path))),
    );
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      // print('A stream error occurred: $e');
    });

    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      log(widget.songs.length.toString());
      _player.setAudioSource(playlist);
    } catch (e, stackTrace) {
      log("Error loading audio source: $e");
      log("Error loading audio source: $stackTrace");
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<AudioProvider>(context,listen: false).playAudio(widget.index);
    });

    // playlist = ConcatenatingAudioSource(
    //   // Start loading next item just before reaching it
    //   useLazyPreparation: true,
    //   // Customise the shuffle algorithm
    //   shuffleOrder: DefaultShuffleOrder(),
    //   // Specify the playlist items
    //
    //   children: List.generate(
    //       0,
    //           (index) =>
    //           AudioSource.uri(Uri.parse('file://${widget.songs[index].name!.path}'))),
    // );
    // _init();

    super.initState();
  }

  @override
  void dispose() {
    // (WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    // _player.stop();
    // _player.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Consumer<AudioProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/jpg/background.jpg'),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              DownloadButton(
                                icon: Icon(
                                  Icons.arrow_back_rounded,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Expanded(
                            child: Text(
                          'Now Playing',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              DownloadButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (ctx) => BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaY: 5, sigmaX: 5),
                                          child: const SaveMusicModal()));
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                            'Click the download button above ☝🏿 to rename and save music.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Card(
                          elevation: 3,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: const DecorationImage(
                                    image:
                                        AssetImage('assets/jpg/background.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Text(
                        'Common Person 1 🔊',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    // CupertinoSlider(
                    //   value: currentRange,
                    //   onChanged: (val) {
                    //     setState(() {
                    //       currentRange = val;
                    //     });
                    //   },
                    //   min: 0,
                    //   max: 6,
                    //   onChangeStart: (val) {},
                    //   onChangeEnd: (val) {},
                    // ),
                    const SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SfSlider(
                        value: currentRange,
                        onChanged: (val) {
                          setState(() {
                            currentRange = val;
                          });
                        },
                        activeColor: Colors.white,
                        min: 0,
                        max: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                               value.previous();
                              },
                              icon: const Icon(
                                Icons.skip_previous_outlined,
                                size: 30,
                              )),
                          !value.isPlaying
                              ? PlayButton(
                                  size: 60,
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.black54,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    value.playAudio(widget.index);
                                  },
                                )
                              : PlayButton(
                                  size: 60,
                                  icon: const Icon(
                                    Icons.pause,
                                    color: Colors.black54,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {
                                    value.pauseAudio();
                                  },
                                ),
                          IconButton(
                              onPressed: () async {
                                value.next();


                                // if(_player.playing){
                                //   log('playing');
                                //   _player.seek(Duration.zero,index:0);
                                //
                                //   // _player.play();
                                //   // _player.dispose();
                                // }
                                // log('message');
                                // _player.audioSource!= null?
                                // _player.play():log('player is null');
                              },
                              icon: const Icon(
                                Icons.skip_next_outlined,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        //       child: Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: MediaQuery.of(context).size.height,
        //   decoration: const BoxDecoration(
        //         image: DecorationImage(
        //             image: AssetImage('assets/jpg/background.jpg'),
        //             fit: BoxFit.cover)),
        //   child: BackdropFilter(
        //       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        //       child: Container(
        //         padding: const EdgeInsets.all(16),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Row(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Row(
        //                     children: [
        //                       DownloadButton(
        //                         icon: Icon(
        //                           Icons.arrow_back_rounded,
        //                           color: Theme.of(context).colorScheme.onPrimary,
        //                           size: 12,
        //                         ),
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //                 const Expanded(
        //                     child: Text(
        //                   'Now Playing',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(color: Colors.white, fontSize: 16),
        //                 )),
        //                 Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Row(
        //                     children: [
        //                       DownloadButton(
        //                         onPressed: () {
        //                           showModalBottomSheet(
        //                               isScrollControlled: true,
        //                               backgroundColor: Colors.transparent,
        //                               context: context,
        //                               builder: (ctx) => BackdropFilter(
        //                                   filter: ImageFilter.blur(
        //                                       sigmaY: 5, sigmaX: 5),
        //                                   child: const SaveMusicModal()));
        //                         },
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ],
        //             ),
        //             const SizedBox(
        //               height: 20,
        //             ),
        //             Center(
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 18),
        //                 child: Text(
        //                     'Click the download button above ☝🏿 to rename and save music.',
        //                     textAlign: TextAlign.center,
        //                     style: TextStyle(
        //                         fontSize: 16,
        //                         color: Theme.of(context).colorScheme.onPrimary)),
        //               ),
        //             ),
        //             Expanded(
        //               child: Center(
        //                 child: Card(
        //                   elevation: 3,
        //                   color: Colors.transparent,
        //                   shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(10)),
        //                   child: Container(
        //                     height: 200,
        //                     width: 200,
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(10),
        //                         image: const DecorationImage(
        //                             image: AssetImage('assets/jpg/background.jpg'),
        //                             fit: BoxFit.cover)),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(
        //               height: 20,
        //             ),
        //             const Center(
        //               child: Text(
        //                 'Common Person 1 🔊',
        //                 style: TextStyle(
        //                     color: Colors.white,
        //                     fontSize: 18,
        //                     fontWeight: FontWeight.w500),
        //               ),
        //             ),
        //             // CupertinoSlider(
        //             //   value: currentRange,
        //             //   onChanged: (val) {
        //             //     setState(() {
        //             //       currentRange = val;
        //             //     });
        //             //   },
        //             //   min: 0,
        //             //   max: 6,
        //             //   onChangeStart: (val) {},
        //             //   onChangeEnd: (val) {},
        //             // ),
        //             const SizedBox(
        //               height: 10,
        //             ),
        //
        //             SizedBox(
        //               width: MediaQuery.of(context).size.width,
        //               child: SfSlider(
        //                 value: currentRange,
        //                 onChanged: (val) {
        //                   setState(() {
        //                     currentRange = val;
        //                   });
        //                 },
        //                 activeColor: Colors.white,
        //                 min: 0,
        //                 max: 30,
        //               ),
        //             ),
        //             const SizedBox(
        //               height: 10,
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 16),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   IconButton(
        //                       onPressed: () {
        //                         _player.stop();
        //                       },
        //                       icon: const Icon(
        //                         Icons.skip_previous_outlined,
        //                         size: 30,
        //                       )),
        //                   const PlayButton(
        //                     size: 60,
        //                     icon: Icon(
        //                       Icons.play_arrow,
        //                       color: Colors.black54,
        //                     ),
        //                     color: Colors.white,
        //                   ),
        //                   IconButton(
        //                       onPressed: ()  async {
        //
        //                         if(_player.playing){
        //                           log('playing');
        //                           _player.seek(Duration.zero,index:0);
        //
        //                           // _player.play();
        //                           // _player.dispose();
        //                         }
        //                         log('message');
        //                         _player.audioSource!= null?
        //                             _player.play():log('player is null');
        //                       },
        //                       icon: const Icon(
        //                         Icons.skip_next_outlined,
        //                         size: 30,
        //                       )),
        //                 ],
        //               ),
        //             ),
        //             const SizedBox(
        //               height: 100,
        //             ),
        //           ],
        //         ),
        //       ),
        //   ),
        // ),
      )),
    );
  }
}
