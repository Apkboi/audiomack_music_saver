import 'package:flutter/material.dart';
import 'package:myplayer/screens/views/home/widgets/custom_button.dart';
import 'package:myplayer/screens/views/home/widgets/filled_text_field.dart';
class SaveMusicModal extends StatefulWidget {
  const SaveMusicModal({Key? key}) : super(key: key);

  @override
  State<SaveMusicModal> createState() => _SaveMusicModalState();
}

class _SaveMusicModalState extends State<SaveMusicModal> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(15),
        height: 240,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:  [

          Text('Save Music',style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.onPrimary,fontWeight: FontWeight.w400),),
          const Text('Enter the song name to save in you device storage and play',style: TextStyle(fontSize: 13,color: Colors.blueGrey,fontWeight: FontWeight.w400),),
          const SizedBox(height: 10,),
          const FilledTextField(),
            const SizedBox(height: 15,),
            Row(
              children: const [
                Expanded(child: CustomButton()),
              ],
            ),

        ],),
      ),
    );
  }
}
