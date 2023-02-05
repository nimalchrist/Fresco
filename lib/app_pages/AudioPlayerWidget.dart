import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PostAudioPlayer extends StatefulWidget {
  final String audioURL;
  final String profilePic;
  final String userName;

  const PostAudioPlayer({
    super.key,
    required this.audioURL,
    required this.profilePic,
    required this.userName,
  });

  @override
  State<PostAudioPlayer> createState() =>
      _PostAudioPlayerState(this.audioURL, this.profilePic, this.userName);
}

class _PostAudioPlayerState extends State<PostAudioPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final String audioURL;
  final String profilePic;
  final String userName;

  _PostAudioPlayerState(this.audioURL, this.profilePic, this.userName);

  @override
  void initState() {
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    super.initState();
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setSourceUrl(audioURL);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 31, 21, 87),
      ),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 15 / 16,
            child: Padding(
              padding: const EdgeInsets.all(68.0),
              child: Image.network(
                'http://192.168.164.221:8000/profile_pics/$profilePic',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            '@$userName',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await audioPlayer.seek(position);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatTime(position),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  formatTime(duration - position),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 25,
            child: IconButton(
                iconSize: 30,
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                    // await audioPlayer.setSourceUrl(audioURL);
                  }
                },
                icon: isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow)),
          ),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
