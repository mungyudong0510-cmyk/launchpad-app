import 'sample.dart';
import 'step.dart';

class Track {
  final String id;
  final String name;
  Sample? sample;
  List<Step> steps;
  double volume;
  bool muted;
  Track({
    required this.id,
    required this.name,
    this.sample,
    this.volume = 1.0,
    this.muted = false,
  }) : steps = List.generate(sample?.category == 'Oneshot' ? 16 : 1, (_) => Step());
}