
import 'dart:convert';

import 'package:yaml/yaml.dart';

class YamlSource {

  late String yaml;
  Map<String, dynamic> get gameDescription => _gameDescription!;
  Map<String, dynamic>? _gameDescription;

  final String yamlString;

  YamlSource(this.yamlString);


  open() async {
    if(_gameDescription != null){
      return;
    }
    try {
      // final yamlString = await rootBundle.loadString('assets/game/game.yaml');
      // final file = File('/Users/siloebezerrabispo/Developer/tcc/novel_game/assets/game.yaml');
      // final yamlString = await file.readAsString();
      // final yamlString = getYamlTeste();
      final yamlMap = loadYaml(yamlString);
      _gameDescription =
          jsonDecode(jsonEncode(yamlMap));
      // print(gameDescription);

    } catch (e) {
      throw 'Erro ao ler o arquivo YAML: $e';
    }
  }


}


String getYamlTeste() {
  return '''
# Definição de cenários e personagens
scenarios:
  - id: park
    title: Parque
    image: park_no_fence_day.jpg
  - id: bus_stop
    title: Ponto de ônibus
    image: bus_stop_morning.jpg
characters:
  - id: warrior
    name: Warrior
    image: warrior.png
  - id: captain
    name: Capitão
    image: captain.png

# Ínicio do jogo
events:
  - add_character: warrior
  - add_character: warrior
  
  ''';
}

