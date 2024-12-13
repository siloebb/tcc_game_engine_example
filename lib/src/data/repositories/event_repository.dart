import 'dart:async';

import 'package:jogotcc/src/data/datasources/yaml_source.dart';
import 'package:jogotcc/src/domain/events/events.dart';
import 'package:jogotcc/src/domain/models/game_objects/dialog.dart';

import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final YamlSource source;
  late final List<Event> _eventsCache;

  EventRepositoryImpl(this.source) {
    _loadCache();
  }

  _loadCache() {
    final eventsRawList = source.gameDescription['events'] as List<dynamic>;
    _eventsCache = eventsRawList.map(
      (e) {
        return _parseAction(e);
      },
    ).toList();
  }

  Event _parseAction(data) {
    try {
      if (data is String) {
        return EventShowText(data);
      }

      if (data is Map) {
        final key = data.keys.first;

        // Check if is a character dialog
        RegExp regex = RegExp(r'^(.*)\s+says$');
        Match? match = regex.firstMatch(key);
        if (match != null) {
          String characterKey = match.group(1)!;
          return EventShowText(data[key], characterKey: characterKey);
        }
        switch (key) {
          case 'add_character':
            return EventAddCharacter(characterKey: data[key]);
          case 'remove_character':
            return EventRemoveCharacter(key: data[key]);
          case 'scenario':
            return EventChangeScenario(data[key]);
          case 'mark':
            return EventLineMark(data[key]);
          case 'go_to_mark':
            return EventGoToLineMark(data[key]);
          case 'end_game':
            return const EventEndGame(true);
          case 'choose':
            final options = (data['choose'] as List)
                .map(
                  (e) =>
                      ChooseOptionModel(
                e['text'],
                keyMarkToGo: e['go_to_mark'],
              ),
            ).toList();
            return EventChooseOption(options);

        }
      }

      return EventNothing();
    }catch (e){
      print('Erro ao parsear evento: $data');
      return EventNothing();
    }
  }

  @override
  Future<List<Event>> getEvents() async {
    return _eventsCache;
  }

  @override
  FutureOr<(Event, int)> getEventByKey(String key) {
    final index = _eventsCache.indexWhere((e) => e is EventLineMark && e.key == key);
    if (index >= 0) {
      return (_eventsCache[index], index);
    }
    throw 'Mark not found';
  }

  @override
  FutureOr<Event> getEvent(int index) {
    return _eventsCache[index];
  }
}
