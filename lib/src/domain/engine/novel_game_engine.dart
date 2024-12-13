
import 'package:jogotcc/src/domain/models/game_objects/character.dart';
import 'package:jogotcc/src/domain/models/game_objects/dialog.dart';
import 'package:jogotcc/src/domain/models/game_objects/scenario.dart';
import 'package:jogotcc/src/domain/repositories/character_repository.dart';
import 'package:jogotcc/src/domain/repositories/scenario_repository.dart';
import 'package:jogotcc/src/domain/repositories/event_repository.dart';
import 'package:jogotcc/src/domain/repositories/game_object_factory.dart';

import '../models/game_objects/game_object.dart';

class NovelGameEngine {

  bool finished = false;

  final CharacterRepository characterRepository;
  final ScenarioRepository scenarioRepository;
  final EventRepository eventRepository;
  final GameObjectViewModelFactory viewModelFactory;

  Function(GameObjectViewModel component) onObjectAdded;
  Function(GameObjectViewModel component) onObjectRemoved;
  
  List<GameObjectViewModel<Character>> currentCharacters = [];
  GameObjectViewModel<Scenario>? currentScenario;

  GameObjectViewModel<Dialog>? currentDialog;

  int currentCommandIndex = -1;

  NovelGameEngine({
    required this.characterRepository,
    required this.scenarioRepository,
    required this.eventRepository,
    required this.viewModelFactory,
    required this.onObjectAdded,
    required this.onObjectRemoved,
  });

  setDialog(Dialog dialog) {
    if(currentDialog != null) {
      onObjectRemoved(currentDialog!);
    }
    final viewModel = viewModelFactory.createViewModel(dialog);
    viewModel.bind(dialog);
    currentDialog = viewModel;
    onObjectAdded(currentDialog!);
  }

  setScenario(Scenario scenario){
    if(currentScenario != null) {
      onObjectRemoved(currentScenario!);
    }
    final viewModel = viewModelFactory.createViewModel(scenario);
    viewModel.bind(scenario);
    currentScenario = viewModel;
    onObjectAdded(currentScenario!);
  }

  void addCharacter(Character character) {
    final viewModel = viewModelFactory.createViewModel(character);
    viewModel.bind(character);
    currentCharacters.add(viewModel);
    onObjectAdded(viewModel);
  }

  void removeCharacter(String id) {
    final obj = currentCharacters.firstWhere((e) => e.id == id);
    currentCharacters.remove(obj);
    onObjectRemoved(obj);
  }

  void clearCharacters() {
    currentCharacters.clear();
    for(final characterComponent in currentCharacters) {
      onObjectRemoved(characterComponent);
    }
  }

  void nextEvent() async {
    if(finished) return;
    if(currentDialog != null) onObjectRemoved(currentDialog!);
    currentDialog = null;
    currentCommandIndex++;
    final nextEvent = await eventRepository.getEvent(currentCommandIndex);
    nextEvent.execute(this);
  }

  void goToEvent(int index) async {
    if(finished) return;
    if(currentDialog != null) onObjectRemoved(currentDialog!);
    currentDialog = null;
    currentCommandIndex = index;
    final nextEvent = await eventRepository.getEvent(currentCommandIndex);
    nextEvent.execute(this);
  }

}