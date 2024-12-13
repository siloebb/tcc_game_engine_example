import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/yaml.dart';
import 'package:jogotcc/src/data/datasources/yaml_source.dart';
import 'package:jogotcc/src/data/repositories/character_repository.dart';
import 'package:jogotcc/src/data/repositories/event_repository.dart';
import 'package:jogotcc/src/data/repositories/scenario_repository.dart';
import 'package:jogotcc/src/presenter/controller/novel_game_controller.dart';
import 'package:jogotcc/src/presenter/view/novel_game_view.dart';

main() {
  runApp(MyApp());
}

GameWidget<NovelGameView> getGame(String yamlString) {
  final source = YamlSource(yamlString);
  source.open();
  final characterRepository = CharacterRepositoryImpl(source);
  final scenarioRepository = ScenarioRepositoryImpl(source);
  final eventRepository = EventRepositoryImpl(source);

  final gameController = NovelGameController(
    characterRepository: characterRepository,
    eventRepository: eventRepository,
    scenarioRepository: scenarioRepository,
  );

  final gameView = NovelGameView(
    controller: gameController,
  );

  return GameWidget(game: gameView);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YAML Editor',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: YamlEditorScreen(),
    );
  }
}

class YamlEditorScreen extends StatefulWidget {
  @override
  _YamlEditorScreenState createState() => _YamlEditorScreenState();
}

class _YamlEditorScreenState extends State<YamlEditorScreen> {
  final TextEditingController _controller =
      TextEditingController(text: gameExampleYaml);

  // final _controller = CodeController(
  //   text: gameExampleYaml, // Initial code
  //   language: yaml,
  // );

  void _onPlayPressed() {
    final yamlText = _controller.text;
    // Simulação de lógica com o YAML
    if (yamlText.isNotEmpty) {
      print("Executando com o seguinte YAML:");
      print(yamlText);
    } else {
      print("Campo YAML vazio.");
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => getGame(yamlText)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editor de YAML')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Expanded(
            //   child: CodeTheme(
            //     data: CodeThemeData(),
            //     child: SingleChildScrollView(
            //       child: CodeField(
            //         controller: _controller,
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null, // Permite múltiplas linhas
                expands: true, // Faz o campo ocupar todo o espaço disponível
                decoration: InputDecoration(
                  hintText: 'Insira seu YAML aqui...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPlayPressed,
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}

const String gameExampleYaml = '''
# Definição de cenários e personagens
scenarios:
  - id: mansion_entrance
    title: Entrada da Mansão
    image: mansion_entrance_night.jpg
  - id: study_room
    title: Sala de Estudos
    image: study_room_dark.jpg
  - id: library
    title: Biblioteca
    image: library_mystical.jpg
  - id: garden
    title: Jardim
    image: garden_full_moon.jpg

characters:
  - id: detective
    name: Detetive Carter
    image: detective_carter.png
  - id: maid
    name: Srta. Rose
    image: maid_rose.png
  - id: owner
    name: Sr. Blackwood
    image: owner_blackwood.png
  - id: ghost
    name: Aparição Misteriosa
    image: ghost_shadow.png

# Ínicio do jogo
events:
  - mark: init_game
  - scenario: mansion_entrance
  - add_character: detective
  - detective says: >
      Esta mansão guarda segredos obscuros.
      Algo terrível aconteceu aqui.
  - detective says: Eu devo investigar para encontrar respostas.
  - remove_character: detective
  - add_character: maid
  - maid says: >
      Sr. Carter, há algo na biblioteca que você precisa ver.
      Mas cuidado, algo... estranho ronda por lá.
  - scenario: library
  - maid says: >
      Vou esperar na sala de estudos, detetive.
      Se precisar de ajuda, chame por mim.
  - remove_character: maid
  - detective says: >
      Esta biblioteca parece ter algo oculto.
      Há livros fora do lugar... e um cheiro de mofo.
  - A luz pisca.
  - add_character: ghost
  - ghost says: >
      Você não deveria estar aqui.
      Este lugar guarda memórias que devem permanecer enterradas.
  - detective says: Quem é você? O que aconteceu aqui?
  - ghost says: >
      Procure no jardim. Você encontrará respostas...
      Ou mais perguntas.
  - remove_character: ghost
  - detective says: Isso está ficando cada vez mais estranho.
  - scenario: garden
  - detective says: >
      O jardim sob a luz da lua... algo foi enterrado aqui.
      Mas o quê?
  - add_character: owner
  - owner says: Detetive! Não toque no solo do jardim!
  - detective says: Sr. Blackwood, por que tanto segredo?
  - owner says: >
      Porque há coisas que nunca deveriam vir à tona...
      Você não entende o perigo que está correndo.
  - choose:
      - text: Ignorar o aviso e cavar
        go_to_mark: uncover_secret
      - text: Escutar e recuar
        go_to_mark: safe_end

  # Rota: Segredo revelado
  - mark: uncover_secret
  - detective says: Vou descobrir a verdade, não importa o que aconteça!
  - Um grito ecoa na noite.
  - add_character: ghost
  - ghost says: Você foi avisado!
  - detective says: >
      Um baú antigo... o que há dentro?
  - ghost says: >
      É tarde demais. Você abriu o portal.
  - mark: bad_end
  - end_game: true

  # Rota: Fim seguro
  - mark: safe_end
  - detective says: Talvez seja melhor recuar por agora.
  - owner says: Uma decisão sábia, detetive.
  - mark: good_end
  - end_game: true
''';
