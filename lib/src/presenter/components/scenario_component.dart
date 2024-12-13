import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';
import 'package:jogotcc/src/domain/models/game_objects/scenario.dart';

class ScenarioComponent extends PositionComponent with GameObjectViewModel<Scenario> {
  late Sprite _sprite;

  @override
  afterBind() {}

  @override
  Future<void> onLoad() async {
    await _loadSprite();
    _updateSize();
    priority = 0;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateSize();
  }

  void _updateSize() {
    final parentGame = findGame() as FlameGame;
    final viewport = parentGame.camera.viewport;
    final cameraSize = viewport.size;

    // Obtém as dimensões do sprite
    final spriteSize = _sprite.srcSize;

    // Calcula o fator de escala necessário para cobrir toda a tela (modo cover)
    final scaleX = cameraSize.x / spriteSize.x;
    final scaleY = cameraSize.y / spriteSize.y;
    final scale = scaleX > scaleY ? scaleX : scaleY;

    // Define o tamanho do componente baseado no fator de escala
    size = Vector2(spriteSize.x * scale, spriteSize.y * scale);

    // Alinha o componente no canto superior esquerdo da tela
    // final left = parentGame.camera.visibleWorldRect.left;
    // final top = parentGame.camera.visibleWorldRect.top;
    // position = Vector2(0, 0);
  }

  Future<void> _loadSprite() async {
    await Flame.images.load(object.image);
    _sprite = Sprite(
      Flame.images.fromCache(object.image),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(
      canvas,
      size: size,
    );
  }
}