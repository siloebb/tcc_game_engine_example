
import 'package:jogotcc/src/domain/engine/novel_game_engine.dart';
import 'package:jogotcc/src/domain/models/game_objects/dialog.dart';

abstract class Event {

  execute(NovelGameEngine engine);
}


class EventNothing implements Event {
  @override
  execute(NovelGameEngine game) {}
}

class EventEndGame implements Event {
  final bool finished;

  const EventEndGame(this.finished);

  @override
  void execute(NovelGameEngine engine) {
    engine.finished = finished;
  }
}

class EventAddCharacter implements Event {
  final String characterKey;

  EventAddCharacter({
    required this.characterKey,
  });

  @override
  execute(NovelGameEngine engine) async {
    final char = await engine.characterRepository.getCharacter(characterKey);
    engine.addCharacter(char);
    engine.nextEvent();
  }
}

class EventRemoveCharacter implements Event {
  final String key;

  EventRemoveCharacter({
    required this.key,
  });

  @override
  execute(NovelGameEngine engine) {
    engine.removeCharacter(key);
    engine.nextEvent();
  }
}

class EventClearCharacters implements Event {
  @override
  execute(NovelGameEngine engine) {
    engine.clearCharacters();
    engine.nextEvent();
  }
}

class EventChangeScenario implements Event {
  final String key;

  EventChangeScenario(this.key);

  @override
  void execute(NovelGameEngine engine) async {
    final scenario = await engine.scenarioRepository.getScenario(key);
    engine.setScenario(scenario);
    engine.nextEvent();
  }
}

class EventShowText implements Event {
  final String text;
  final String? characterKey;

  const EventShowText(this.text, {this.characterKey});

  @override
  void execute(NovelGameEngine engine) async {
    String? characterName;
    if(characterKey != null) {
      final char = await engine.characterRepository.getCharacter(characterKey!);
      characterName = char.name;
    }
    DialogText dialogText = DialogText(characterName: characterName, text: text);
    engine.setDialog(dialogText);
  }
}

class EventChooseOption implements Event {
  final List<ChooseOptionModel> options;

  const EventChooseOption(this.options);

  @override
  void execute(NovelGameEngine engine) {
    final dialogChooser = DialogChooser(options: options);
    engine.setDialog(dialogChooser);
  }
}

class EventLineMark implements Event {
  final String key;

  const EventLineMark(this.key);

  @override
  void execute(NovelGameEngine engine) {
    engine.nextEvent();
  }
}

class EventGoToLineMark implements Event {
  final String key;

  const EventGoToLineMark(this.key);

  @override
  void execute(NovelGameEngine engine) async {
    final (Event, int) result = await engine.eventRepository.getEventByKey(key);

    engine.goToEvent(result.$2);
  }
}