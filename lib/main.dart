import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: My(),
    );
  }
}

class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {
  final FlutterMidi flutterMidi = FlutterMidi();
  String path = 'assets/Yamaha-Grand-Lite-SF-v1.1.sf2';

  @override
  void initState() {
    load(path);
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    flutterMidi.prepare(sf2: byte, name: path.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<String>(
            value: path,
            onChanged: (String? value) {
              setState(() {
                path = value!;
                load(value);
              });
            },
            items: const [
              DropdownMenuItem(
                value: 'assets/Yamaha-Grand-Lite-SF-v1.1.sf2',
                child: Text('Piano'),
              ),
              DropdownMenuItem(
                value: 'assets/Expressive Flute SSO-v1.2.sf2',
                child: Text('Flute'),
              ),
              DropdownMenuItem(
                value: 'assets/Best of Guitars-4U-v1.0.sf2',
                child: Text('Guitar'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: InteractivePiano(
          highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 65,
          noteRange: NoteRange.forClefs([
            Clef.Treble,
            Clef.Alto,
            Clef.Bass,
          ]),
          onNotePositionTapped: (position) {
            flutterMidi.playMidiNote(midi: position.pitch);
            Future.delayed(const Duration(milliseconds: 100), () {
              flutterMidi.stopMidiNote(midi: position.pitch);
            });
          },
        ),
      ),
    );
  }
}
