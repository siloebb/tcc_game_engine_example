import 'package:jogotcc/src/domain/engine/novel_game_engine.dart';
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';
import 'package:jogotcc/src/domain/repositories/character_repository.dart';
import 'package:jogotcc/src/domain/repositories/event_repository.dart';
import 'package:jogotcc/src/domain/repositories/scenario_repository.dart';
import 'package:jogotcc/src/presenter/controller/commands.dart';

import '../view/novel_game_view.dart';

class NovelGameController {
  final CharacterRepository characterRepository;
  final ScenarioRepository scenarioRepository;
  final EventRepository eventRepository;
  late final NovelGameEngine engine;

  Function(GameObjectViewModel component)? onObjectAdded;
  Function(GameObjectViewModel component)? onObjectRemoved;

  NovelGameController({
    required this.characterRepository,
    required this.scenarioRepository,
    required this.eventRepository,
  });

  initGame({
    required Function(GameObjectViewModel component) onObjectAdded,
    required Function(GameObjectViewModel component) onObjectRemoved,
  }) {
    engine = NovelGameEngine(
      onObjectAdded: onObjectAdded,
      onObjectRemoved: onObjectRemoved,
      eventRepository: eventRepository,
      characterRepository: characterRepository,
      scenarioRepository: scenarioRepository,
      viewModelFactory: GameObjectFactory(this),
    );
  }

  emmitCommand(Command command) {
    if (command == Command.confirm) {
      engine.nextEvent();
    }
  }

}
