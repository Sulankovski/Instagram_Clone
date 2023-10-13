import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  final File videoFile;
  final String videoPath;

  const ConfirmScreen({
    super.key,
    required this.videoFile,
    required this.videoPath,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  // late VideoPlayerController videoContreoller;
  late final TextEditingController _songController = TextEditingController();
  late final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print("pat");
    print(widget.videoPath);
    // setState(() {
    //   videoContreoller = VideoPlayerController.file(widget.videoFile);
    // });
    // videoContreoller.initialize();
    // videoContreoller.play();
    // videoContreoller.setVolume(1);
    // videoContreoller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    // videoContreoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height / 1.5,
            //   width: MediaQuery.of(context).size.width,
            //   child: VideoPlayer(videoContreoller),
            // ),
            const SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _songController,
                      label: "Song name",
                      icon: Icons.music_note_outlined,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width - 20,
                    child: TextInputField(
                      controller: _captionController,
                      label: "Caption",
                      icon: Icons.closed_caption,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () => AuthMethods().upladVideo(_songController.text, _captionController.text, widget.videoPath),
                    child: const Text(
                      "Post",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
