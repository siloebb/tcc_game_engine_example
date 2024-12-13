import 'package:jogotcc/src/data/datasources/yaml_source.dart';
import 'package:jogotcc/src/domain/models/game_objects/character.dart';
import 'package:jogotcc/src/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  final YamlSource source;

  late final Map<String, Character> _charactersCache;

  CharacterRepositoryImpl(this.source) {
    _loadCache();
  }

  _loadCache() {
    final charactersData =
        (source.gameDescription['characters'] as List<dynamic>).map(
      (e) {
        return Character(
          id: e['id'] as String,
          name: e['name'] as String,
          image: e['image'] as String,
        );
      },
    ).toList();

    _charactersCache = Map.fromEntries(
      charactersData.map(
        (e) => MapEntry(e.id, e),
      ),
    );
  }

  @override
  Future<Character> getCharacter(String id) async {
    return _charactersCache[id]!;
  }

  @override
  Future<List<Character>> getCharacters() async {
    return _charactersCache.values.toList();
  }
}
