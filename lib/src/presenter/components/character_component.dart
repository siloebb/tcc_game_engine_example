import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:jogotcc/src/domain/models/game_objects/character.dart';
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';

class CharacterComponent extends PositionComponent
    with GameObjectViewModel<Character> {

  late Sprite _sprite;

  @override
  afterBind() {}

  @override
  Future<void> onLoad() async {
    await _loadSprite();
    _updateSize();
    priority = 10;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateSize();
  }

  _updateSize(){
    final parentGame = findGame() as FlameGame;
    final viewport = parentGame.camera.viewport;
    final cameraSize = viewport.size;
    // size = Vector2(cameraSize.x, height);
    // size = Vector2(100, 100);
    final spriteSize = _sprite.srcSize;


    final leftInit = parentGame.camera.visibleWorldRect.left;
    final shiftLeft = (cameraSize.x / 2) - (spriteSize.x / 2);
    // final top = parentGame.camera.visibleWorldRect.top;

    position = Vector2(shiftLeft, 0);
  }

  _loadSprite() async {
    await Flame.images.load(object.image);
    _sprite = Sprite(
      Flame.images.fromCache(object.image),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas);
  }

}
