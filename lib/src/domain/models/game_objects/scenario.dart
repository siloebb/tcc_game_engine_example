
import 'game_object.dart';

class Scenario extends GameObject {
  @override
  final String id;
  final String? title;
  final String image;

  Scenario({required this.id, this.title, required this.image});

}