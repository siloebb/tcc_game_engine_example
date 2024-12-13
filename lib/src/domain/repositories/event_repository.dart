import 'dart:async';

import '../events/events.dart';

abstract class EventRepository {
  FutureOr<List<Event>> getEvents();

  FutureOr<Event> getEvent(int index);

  FutureOr<(Event, int)> getEventByKey(String key);
}
