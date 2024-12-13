
import '../models/game_objects/scenario.dart';

abstract class ScenarioRepository {
  Future<List<Scenario>> getScenarios();
  Future<Scenario> getScenario(String id);
}