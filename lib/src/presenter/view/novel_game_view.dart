import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:jogotcc/src/domain/engine/novel_game_engine.dart';
import 'package:jogotcc/src/domain/events/events.dart';
import 'package:jogotcc/src/domain/models/game_objects/character.dart';
import 'package:jogotcc/src/domain/models/game_objects/dialog.dart';
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';
import 'package:jogotcc/src/domain/models/game_objects/scenario.dart';
import 'package:jogotcc/src/domain/repositories/game_object_factory.dart';
import 'package:jogotcc/src/presenter/components/dialog.dart';
import 'package:jogotcc/src/presenter/components/scenario_component.dart';
import 'package:jogotcc/src/presenter/controller/commands.dart';
import 'package:jogotcc/src/presenter/controller/novel_game_controller.dart';

import '../components/character_component.dart';

class NovelGameView extends FlameGame with TapCallbacks {
  final NovelGameController controller;

  NovelGameView({required this.controller});

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    controller.initGame(
      onObjectAdded: onObjectAdded,
      onObjectRemoved: onObjectRemoved,
    );
    // add(dialog);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if(children.whereType<DialogChooserBalloon>().isNotEmpty) {
      return;
    }
    controller.emmitCommand(Command.confirm);
  }

  onObjectAdded(GameObjectViewModel component) {
    add(component as Component);
  }

  onObjectRemoved(GameObjectViewModel component) {
    remove(component as Component);
  }

  @override
  render(Canvas canvas) {
    super.render(canvas);
  }
}

class GameObjectFactory extends GameObjectViewModelFactory {
  NovelGameController controller;

  GameObjectFactory(this.controller);

  @override
  GameObjectViewModel? createViewModel(GameObject object) {
    if (object is Character) {
      return CharacterComponent();
    }
    if (object is Scenario) {
      return ScenarioComponent();
    }
    if (object is DialogText) {
      return DialogBalloon();
    }
    if (object is DialogChooser) {
      return DialogChooserBalloon(
        onOptionSelected: (key) {
          if (key == null) {
            controller.engine.nextEvent();
          } else {
            EventGoToLineMark(key).execute(
              controller.engine,
            );
          }
        },
      );
    }
    return null;
  }
}
