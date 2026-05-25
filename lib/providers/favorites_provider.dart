import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteGroup {
  final String id;
  final String name;
  final String type;

  FavoriteGroup({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
      };

  factory FavoriteGroup.fromJson(Map<String, dynamic> json) {
    return FavoriteGroup(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }
}

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteGroup> _favorites = [];

  List<FavoriteGroup> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    _favorites = favoritesJson
        .map((json) => FavoriteGroup.fromJson(jsonDecode(json)))
        .toList();
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteGroup group) async {
    if (!_favorites.any((f) => f.id == group.id)) {
      _favorites.add(group);
      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((f) => f.id == id);
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((f) => f.id == id);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favorites
        .map((group) => jsonEncode(group.toJson()))
        .toList();
    await prefs.setStringList('favorites', favoritesJson);
  }
}