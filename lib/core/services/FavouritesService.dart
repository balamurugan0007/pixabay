import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixabay/features/Images/data/model/PixabayImage.dart';

class FavouritesService {
  static const _key = 'favourite_images';

  Future<List<PixabayImage>> loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((e) => PixabayImage.fromJson(jsonDecode(e)))
        .toList();
  }

 
  Future<void> _save(List<PixabayImage> images) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = images.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, raw);
  }

  
  Future<bool> isFavourite(PixabayImage image) async {
    final favs = await loadFavourites();
    return favs.any((f) => f.id == image.id);
  }


  Future<bool> toggleFavourite(PixabayImage image) async {
    final favs = await loadFavourites();
    final exists = favs.any((f) => f.id == image.id);
    if (exists) {
      favs.removeWhere((f) => f.id == image.id);
    } else {
      favs.add(image);
    }
    await _save(favs);
    return !exists;
  }
}
