import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myplayer/screens/views/home/widgets/play_button.dart';

import '../../../widgets/gradient_button.dart';

class BannerItem extends StatefulWidget {
  const BannerItem({Key? key}) : super(key: key);

  @override
  State<BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<BannerItem> {
  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.all(10),
      decoration:  BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('assets/jpg/musiclistener.jpg'),
              fit: BoxFit.cover),
      borderRadius: BorderRadius.circular(10)
      ),
      child:  Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaY: 4,
                  sigmaX: 4,
                ),
                child: Container(


                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [

                            Text('Common Person',style: TextStyle(color: Colors.white),),
                            SizedBox(height: 5,),
                            Text('Afro-Beat',style: TextStyle(color: Colors.blueGrey,fontSize: 13),)
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                        PlayButton(size: 30, icon: const Icon(Icons.play_arrow_rounded,size: 16,color: Colors.white,), onPressed: () {  },)
                      // IconButton(onPressed: (){}, icon: const Icon(Icons.play_arrow))
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
