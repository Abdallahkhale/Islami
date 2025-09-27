import 'package:flutter/material.dart';
import 'package:islami/Core/Assets/Colors.dart';
import 'package:islami/Core/Assets/icons.dart';
import 'package:audioplayers/audioplayers.dart';

class Customcard extends StatefulWidget {
  final String title;
  final String audioUrl;
  final bool isRadio;

  const Customcard({
    super.key,
    required this.title,
    required this.audioUrl,
    required this.isRadio,
  });

  @override
  State<Customcard> createState() => _CustomcardState();
}

class _CustomcardState extends State<Customcard> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    
    // Listen to player state changes
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    // Listen to position changes to detect when audio starts
    audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });

    // Listen for audio completion
    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playAudio() async {
    try {
      setState(() {
        isLoading = true;
      });

      await audioPlayer.play(UrlSource(widget.audioUrl));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> pauseAudio() async {
    await audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: ColorsApp.gold,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(IconsPath.bottomlogo),
          opacity: 0.5,
          colorFilter: ColorFilter.mode(
            Colors.black,
            BlendMode.srcIn,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              else
                IconButton(
                  onPressed: isPlaying ? pauseAudio : playAudio,
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  color: Colors.black,
                  iconSize: 32,
                ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: stopAudio,
                icon: const Icon(Icons.stop),
                color: Colors.black,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}