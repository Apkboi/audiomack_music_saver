import 'package:flutter/material.dart';
import 'package:myplayer/helpers/enums.dart';
import 'package:myplayer/providers/audio_provider.dart';
import 'package:myplayer/providers/music_providers.dart';
import 'package:myplayer/screens/views/home/widgets/banner_item.dart';
import 'package:myplayer/screens/views/home/widgets/music_list_item.dart';
import 'package:myplayer/screens/views/home/widgets/sliver_persistent_delegate.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/enums.dart';
import '../../player/views/music_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<MusicProvider>(context, listen: false).getAudiomackSongs();
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   Provider.of<MusicProvider>(context,listen: false).getAudiomackSongs();
    // });
  }

  @override
  Widget build(BuildContext context) {
    // var musicProvider = Provider.of<MusicProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.red,
        ),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // const SliverToBoxAdapter(child: SizedBox(height: 50,),),
              SliverPersistentHeader(
                  floating: true,
                  delegate: SliverAppBarDelegate(
                    PreferredSize(
                      preferredSize: const Size.fromHeight(100),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Hello  👋🏿',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    'Welcome back guest!',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  )
                                ],
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.dark_mode_outlined,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 30,
                                ))
                          ],
                        ),
                      ),
                    ),
                  )),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: PageController(viewportFraction: 0.7),
                    allowImplicitScrolling: true,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      var _scale = currentIndex == index ? 1.0 : 0.8;
                      return TweenAnimationBuilder<double>(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 335),
                        tween: Tween(begin: _scale, end: _scale),
                        builder: (context, value, child) {
                          return Transform.scale(
                            child: child,
                            scale: value,
                          );
                        },
                        child: BannerItem(),
                      );
                    },
                  ),
                ),
              ),
            ];
          },
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Songs ',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
                const SizedBox(
                  height: 5,
                ),
                Consumer<MusicProvider>(
                  builder: (BuildContext context, value, Widget? child) {
                    if (value.getMusicState == GetMusicState.loading) {
                      return const Expanded(
                          child: Center(
                        child: CircularProgressIndicator(),
                      ));
                    } else if (value.getMusicState == GetMusicState.success) {
                      // Update playlist Here
                      Provider.of<AudioProvider>(context).init(
                        value.audiomackSongs,
                      );
                      return Expanded(
                        child: ListView.builder(
                          itemCount: value.audiomackSongs.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MusicPlayerScreen(
                                    index: index,
                                    songs: value.audiomackSongs,
                                  ),
                                ));
                              },
                              child: MusicListItem(
                                song: value.audiomackSongs[index],
                              )),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('ERROR',style: TextStyle(color: Colors.red),),
                      );
                    }
                  },

                  //   return  value.getMusicState == GetMusicState.loading?
                  //     const Center(child: CircularProgressIndicator(),):
                  //     Expanded(
                  //   child: ListView.builder(
                  //     padding: EdgeInsets.zero,
                  //     itemBuilder: (context, index) => const MusicListItem(),
                  //   ),
                  // ); },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
