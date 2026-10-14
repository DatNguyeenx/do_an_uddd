import 'package:flutter/foundation.dart';

import '../data/places_data.dart';

class CheckInEntry {
  CheckInEntry({required this.place, required this.note}) : createdAt = DateTime.now();

  final Place place;
  final String note;
  final DateTime createdAt;
}

/// Demo history kept in memory; it does not verify location or persist to a server.
class CheckInProvider extends ChangeNotifier {
  final List<CheckInEntry> _entries = [];

  List<CheckInEntry> get entries => List.unmodifiable(_entries);

  bool hasVisited(String placeId) => _entries.any((entry) => entry.place.id == placeId);

  void add(Place place, String note) {
    _entries.insert(0, CheckInEntry(place: place, note: note));
    notifyListeners();
  }

  void remove(CheckInEntry entry) {
    _entries.remove(entry);
    notifyListeners();
  }
}
