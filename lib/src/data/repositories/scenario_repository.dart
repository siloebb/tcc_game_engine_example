
import 'package:jogotcc/src/domain/models/game_objects/scenario.dart';
import 'package:jogotcc/src/domain/repositories/scenario_repository.dart';

import '../datasources/yaml_source.dart';

class ScenarioRepositoryImpl extends ScenarioRepository {
  final YamlSource source;

  late final Map<String, Scenario> _scenarioCache;

  ScenarioRepositoryImpl(this.source) {
    _loadCache();
  }

  _loadCache() {
    final scenariosData =
    (source.gameDescription['scenarios'] as List<dynamic>).map(
          (e) {
        return Scenario(
          id: e['id'] as String,
          title: e['title'] as String,
          image: e['image'] as String,
        );
      },
    ).toList();

    _scenarioCache = Map.fromEntries(
      scenariosData.map(
            (e) => MapEntry(e.id, e),
      ),
    );
  }

  @override
  Future<Scenario> getScenario(String id) async {
    return _scenarioCache[id]!;
  }

  @override
  Future<List<Scenario>> getScenarios() async {
    return _scenarioCache.values.toList();
  }
}