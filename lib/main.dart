import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(const XylophoneApp());

Future<void> playSound(AudioPlayer pllp, int noteNumber) async {
  final player = AudioPlayer();
  await player.play(AssetSource('note$noteNumber.wav'));
}

Widget musicButton(Color color, int noteNumber) {
  return Expanded(
    child: Container(color: color),
  );
}

ButtonStyle musicButtonStyle(Color color) {
  return TextButton.styleFrom(backgroundColor: color);
}

class XylophoneApp extends StatefulWidget {
  const XylophoneApp({Key? key}) : super(key: key);

  @override
  State<XylophoneApp> createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  final GlobalKey _widgetKey = GlobalKey();
  double noteHeight = 0.0;
  double height = 0.0;
  double offset = 0.0;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.brown,
        body: SafeArea(
          child: GestureDetector(
            onPanUpdate: (details) {
              double dy = details.globalPosition.dy;
              double prev_dy = dy + details.delta.dy;
              if (noteHeight == 0.0) {
                RenderBox renderBox =
                    _widgetKey.currentContext?.findRenderObject() as RenderBox;

                height = renderBox.size.height;
                offset = renderBox.localToGlobal(Offset.zero).dy;
                noteHeight = height / 7;
              }
              DragUpdateDetails o; //test
              if (dy > offset && dy < height + offset) {
                dy -= offset;
                int note = dy ~/ noteHeight;
                note += 1;

                prev_dy -= offset;
                int prevNote = prev_dy ~/ noteHeight;
                prevNote += 1;

                if (prevNote != note) {
                  playSound(player, prevNote);
                }
              }
            },
            onPanStart: (details) {
              double dy = details.globalPosition.dy;
              if (noteHeight == 0.0) {
                RenderBox renderBox =
                    _widgetKey.currentContext?.findRenderObject() as RenderBox;

                height = renderBox.size.height;
                offset = renderBox.localToGlobal(Offset.zero).dy;
                noteHeight = height / 7;
              }
              DragUpdateDetails o; //test
              if (dy > offset && dy < height + offset) {
                dy -= offset;
                int note = dy ~/ noteHeight;
                note += 1;

                playSound(player, note);
              }
            },
            onPanEnd: (details) {},
            child: Column(
              key: _widgetKey,
              children: [
                musicButton(Colors.red, 1),
                musicButton(Colors.orange, 2),
                musicButton(Colors.yellow, 3),
                musicButton(Colors.green, 4),
                musicButton(Colors.cyan, 5),
                musicButton(Colors.blue, 6),
                musicButton(Colors.purple, 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
