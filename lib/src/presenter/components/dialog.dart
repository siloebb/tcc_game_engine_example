import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:jogotcc/src/domain/events/events.dart';
import 'package:jogotcc/src/domain/models/game_objects/dialog.dart';
import 'package:jogotcc/src/domain/models/game_objects/game_object.dart';

class DialogBalloon extends PositionComponent
    with GameObjectViewModel<DialogText> {
  final double padding;
  final double height;
  final TextStyle characterNameStyle;
  final TextStyle textStyle;

  DialogBalloon({
    this.padding = 16.0,
    this.height = 100.0,
    this.characterNameStyle = const TextStyle(fontSize: 16, color: Colors.blue),
    this.textStyle = const TextStyle(fontSize: 16, color: Colors.white),
  }) : super(position: Vector2.zero());

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;
    _updateSize();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateSize();
  }

  void _updateSize() {
    final parentGame = findGame() as FlameGame;
    final viewportSize = parentGame.camera.viewport.size;

    size = Vector2(viewportSize.x, height);
    position = Vector2(0, viewportSize.y - height);
  }

  void _renderBalloon(Canvas canvas) {
    final paintBackground = Paint()..color = Colors.black.withOpacity(0.8);
    final paintBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(0, 0, size.x, height);
    canvas.drawRect(rect, paintBackground);
    canvas.drawRect(rect, paintBorder);
  }

  void _renderText(Canvas canvas) {
    final List<TextSpan> spans = [];

    if (object.characterName != null) {
      spans.add(TextSpan(
        text: '${object.characterName}: ',
        style: characterNameStyle,
      ));
    }

    spans.add(TextSpan(
      text: object.text,
      style: textStyle,
    ));

    final textSpan = TextSpan(children: spans);

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.x - 2 * padding);

    final offset = Offset(padding, (height - textPainter.height) / 2);

    textPainter.paint(canvas, offset);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _renderBalloon(canvas);
    _renderText(canvas);
  }
}

class DialogChooserBalloon extends PositionComponent
    with GameObjectViewModel<DialogChooser> {
  final double padding;
  final double optionSpacing;
  final double height;
  final TextStyle optionTextStyle;
  final TextStyle selectedOptionTextStyle;
  final Function(String?)? onOptionSelected;

  DialogChooserBalloon({
    this.padding = 16.0,
    this.optionSpacing = 10.0,
    this.height = 150.0,
    this.optionTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    this.selectedOptionTextStyle = const TextStyle(
      fontSize: 16,
      color: Colors.yellow,
    ),
    this.onOptionSelected,
  }) : super(position: Vector2.zero());

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 100;
    _updateSize();
    _createOptions();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _updateSize();
  }

  void _updateSize() {
    final parentGame = findGame() as FlameGame;
    final viewportSize = parentGame.camera.viewport.size;

    size = Vector2(viewportSize.x, height);
    position = Vector2(0, viewportSize.y - height);
  }

  void _createOptions() {
    // Criar novos componentes de texto para cada opção
    double currentY = padding;
    for (var option in object.options) {
      final optionComponent = _ClickableOption(
        text: option.text,
        position: Vector2(padding, currentY),
        textStyle: optionTextStyle,
        onSelected: () {
          if (onOptionSelected != null) {
            onOptionSelected!(option.keyMarkToGo);
          }
        },
      );

      add(optionComponent);
      currentY +=
          optionComponent.height + optionSpacing; // Avança para próxima linha
    }
  }

  void _renderBalloon(Canvas canvas) {
    final paintBackground = Paint()..color = Colors.black.withOpacity(0.8);
    final paintBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(0, 0, size.x, height);
    canvas.drawRect(rect, paintBackground);
    canvas.drawRect(rect, paintBorder);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _renderBalloon(canvas);
  }
}

class _ClickableOption extends PositionComponent with TapCallbacks {
  final String text;
  final TextStyle textStyle;
  final VoidCallback onSelected;

  late TextComponent _textComponent;

  _ClickableOption({
    required this.text,
    required Vector2 position,
    required this.textStyle,
    required this.onSelected,
  }) : super(position: position) {
    _textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(style: textStyle),
      position: Vector2.zero(),
    );

    add(_textComponent);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = _textComponent.size;
  }

  @override
  bool containsPoint(Vector2 point) {
    return toRect().contains(point.toOffset());
  }

  @override
  void onTapDown(TapDownEvent event) {
    onSelected();
  }
}
