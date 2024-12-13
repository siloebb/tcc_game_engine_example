
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';

abstract class Dialog extends GameObject {}

class DialogText extends Dialog {
  final String? characterName;
  final String text;

  DialogText({required this.characterName, required this.text});

  @override
  String get id => 'dialog';

}

class DialogChooser extends Dialog {
  final List<ChooseOptionModel> options;

  DialogChooser({required this.options});

  @override
  String get id => 'dialog';
}

class ChooseOptionModel {
  final String text;
  final String? keyMarkToGo;

  ChooseOptionModel(this.text, {this.keyMarkToGo});
}