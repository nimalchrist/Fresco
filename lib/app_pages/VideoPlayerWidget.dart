import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class PostVideoPlayer extends StatefulWidget {
  final String videoURL;
  PostVideoPlayer({Key? key, required this.videoURL}) : super(key: key);
  @override
  _PostVideoPlayerState createState() => _PostVideoPlayerState(videoURL);
}

class _PostVideoPlayerState extends State<PostVideoPlayer> {
  final String videoURL;
  CachedVideoPlayerController? controller;
  Future<void>? initializeVideoPlayerController;
  double playbackSpeed = 1;
  List<double> playbackSpeeds = [0.5, 1.0, 1.25, 1.5, 2.0];

  _PostVideoPlayerState(this.videoURL);

  @override
  void initState() {
    controller = CachedVideoPlayerController.network(videoURL);
    initializeVideoPlayerController = controller!.initialize();
    controller!.setLooping(true);
    controller!.setVolume(1);
    controller!.setPlaybackSpeed(playbackSpeed);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerController,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              AspectRatio(
                aspectRatio: controller!.value.aspectRatio,
                child: CachedVideoPlayer(controller!),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: DropdownButton(
                            alignment: Alignment.bottomCenter,
                            dropdownColor: Colors.black,
                            iconSize: 30,
                            iconEnabledColor: Colors.white,
                            value: playbackSpeed,
                            items: playbackSpeeds.map((speed) {
                              return DropdownMenuItem(
                                value: speed,
                                child: Text(
                                  '${speed}x',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (double? newSpeed) {
                              setState(() {
                                playbackSpeed = newSpeed!;
                                controller!.setPlaybackSpeed(playbackSpeed);
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 16,
                            bottom: 16,
                          ),
                          child: IconButton(
                            icon: Icon(
                              color: Colors.white,
                              size: 40,
                              controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              setState(() {
                                controller!.value.isPlaying
                                    ? controller!.pause()
                                    : controller!.play();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 16,
                            bottom: 16,
                          ),
                          child: IconButton(
                            icon: Icon(
                              size: 37,
                              color: Colors.white,
                              controller!.value.volume == 0
                                  ? Icons.volume_off
                                  : Icons.volume_up,
                            ),
                            onPressed: () {
                              setState(() {
                                controller!.value.volume == 0
                                    ? controller!.setVolume(1)
                                    : controller!.setVolume(0);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 14,
                  child: VideoProgressIndicator(
                    controller!,
                    allowScrubbing: true,
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
