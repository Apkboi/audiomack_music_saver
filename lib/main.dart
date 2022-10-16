import 'dart:developer';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:myplayer/providers/audio_provider.dart';
import 'package:myplayer/providers/music_providers.dart';
import 'package:myplayer/providers/platform_provider.dart';
import 'package:myplayer/screens/views/welcome_screen.dart';
import 'package:myplayer/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   final session = await AudioSession.instance;
   await session.configure(const AudioSessionConfiguration.music());
   try {

   await  JustAudioBackground.init(
      androidNotificationChannelId: 'id',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      preloadArtwork: true



       ).then((value) => {
      log('initialized')
     });

   } on Exception catch (e) {
     log(e.toString());
   }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MusicProvider>(
          create: (context) => MusicProvider(),
        ),
        ChangeNotifierProvider<PlatformProvider>(
          create: (context) => PlatformProvider(),
        ),
        ChangeNotifierProvider<AudioProvider>(
          create: (context) => AudioProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        home: const WelcomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<FileSystemEntity> files = [];
  List<Map<String, dynamic>> audiomackSongs = [];

  // AudioPlayer audioPlayer = AudioPlayer();



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
    List<FileSystemEntity> songs = [];
    List<FileSystemEntity> image = [];
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

          if (songPath.path !=
                  '/storage/emulated/0/Download/com.audiomack/files/Audiomack/artworks' &&
              songPath.path != '.nomedia') {
            log(songDirectory);
            // FileSystemEntity copiedSong = await  songPath.copySync('$songDirectory/$i.mp3');
            audiomackSongs.add({"song": songPath, "image": imagePath});
            log(' ALL ${{"song": songPath.path, "image": imagePath}}');
          } else {}
        }
      } catch (e) {
        // var excpt = e as FileSystemException;
        // log(' ERROR :${excpt.osError!.message.toString()}');
        log(e.toString());
      }
    }
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
              songPath.copySync('$songDirectory/$i.mp3');
          audiomackSongs.add({"song": copiedSong, "image": imagePath});
          log(' ALL ${{"song": copiedSong.path, "image": imagePath}}');
        } else {}
      }
    } catch (e) {
      // var excpt = e as FileSystemException;
      // log(' ERROR :${excpt.osError!.message.toString()}');
      log(e.toString());
    }
  }

  Future<void> getFiles(BuildContext context) async {

        await getApplicationDocumentsDirectory().then((value) async {
      log(value.path);

      try {
        files = Directory('/storage/emulated/0/Download/com.audiomack/files/')
            .listSync();
      } catch (e) {
        var excpt = e as FileSystemException;
        log(excpt.osError!.message.toString());
      }
      return value;
    });
    log(files.length.toString());
  }

  @override
  void initState() {
    super.initState();
    // getFiles(context);
    // files = Directory('').listSync();
    // initAndroidPaths();
    getAudiomackSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.headline4,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: audiomackSongs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    File file = (audiomackSongs[index]['song'] as File);
                    log('file://${audiomackSongs[index]['song']}');
                    // audioPlayer.play(audiomackSongs[index]['song'],isLocal: true);
                    try {
                      final player = AudioPlayer(); // Create a player
                      // player.setAudioSource(AudioSource.uri())
                      await player.setAudioSource(// Load a URL
                          AudioSource.uri(Uri.parse(
                              'file://${file.path}'))); // Schemes: (https: | file: | asset: )
                      // AudioSource.uri(Uri.parse('https://commondatastorage.googleapis.com/codeskulptor-assets/Evillaugh.ogg')));                 // Schemes: (https: | file: | asset: )

                      // player.pla
                      player.play(); // Play without waiting for completion
                      await player.play().then((value) {
                        log('playing');
                      });
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: ListTile(
                    title: Text((audiomackSongs[index]['song'] as File).path),
                    trailing: Image.file(
                      audiomackSongs[index]['image'],
                      height: 100,
                      width: 200,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void playAudio() {
    // audioPlayer.setAudioSource()

    // audioPlayer.play(DeviceFileSource());
  }
}
