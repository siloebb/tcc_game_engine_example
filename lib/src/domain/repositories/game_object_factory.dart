
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';

abstract class GameObjectViewModelFactory<GameObjectViewModel> {

  GameObjectViewModel? createViewModel(GameObject object);

}