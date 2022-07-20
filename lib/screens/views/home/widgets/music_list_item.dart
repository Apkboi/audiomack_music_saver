import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:myplayer/screens/views/home/widgets/download_button.dart';
import 'package:myplayer/screens/views/player/views/music_player_screen.dart';

import '../../../../models/song.dart';

class MusicListItem extends StatefulWidget {
  const MusicListItem({Key? key, required this.song}) : super(key: key);
  final Song song;

  @override
  State<MusicListItem> createState() => _MusicListItemState();
}

class _MusicListItemState extends State<MusicListItem> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      // padding: const EdgeInsets.symmetric(horizontal: 10,),
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0.0,
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child:ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                    widget.song.image!, height: 50,
                  width: 50,)),
            // child: Container(
            //   height: 50,
            //   width: 50,
            //
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       image:  DecorationImage(
            //           image: AssetImage(widget.song['image'].toString()),
            //           fit: BoxFit.cover)),
            // ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
            widget.song.name!=null?
                    widget.song.name!.path.toString().split('/').last:'f',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary)),
                const SizedBox(
                  height: 2,
                ),
                 Text(getDuration(widget.song.duration!),
                    style: const TextStyle(fontSize: 13, color: Colors.blueGrey)),
              ],
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: DownloadButton(),
          )
        ],
      ),
    );
  }
  String getDuration(Duration duration){
   if( duration.inHours!=0){
     return '${duration.inHours}:${duration.inMinutes}:${duration.inSeconds.toString()[0]} hrs';
   }else{
     return '${duration.inMinutes}:${duration.inSeconds.toString()[0]} minutes';
   }
  }
}
