import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import './VideoPlayerWidget.dart';

class VideoViewer extends StatefulWidget {
  final String videoURL;
  const VideoViewer({super.key, required this.videoURL});

  @override
  State<VideoViewer> createState() => _VideoViewerState(this.videoURL);
}

class _VideoViewerState extends State<VideoViewer> {
  final String videoURL;
  _VideoViewerState(this.videoURL);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              PostVideoPlayer(videoURL: videoURL),
              IconButton(
                color: Colors.white,
                iconSize: 30,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
