import 'track.dart';

class Pattern {
  final String id;
  String name;
  List<Track> tracks;
  int stepCount;

  Pattern({
    required this.id,
    required this.name,
    this.stepCount = 16
  }) : tracks = [
        Track(id: 'kick', name: 'Kick'),
        Track(id: 'snare', name: 'Snare'),
        Track(id: 'hihat', name: 'Hi-Hat'),
        Track(id: 'clap', name: 'Clap'),
        Track(id: 'tom1', name: 'Tom 1'),
        Track(id: 'tom2', name: 'Tom 2'),
        Track(id: 'perc1', name: 'Perc 1'),
        Track(id: 'perc2', name: 'Perc 2'),
      ];
}