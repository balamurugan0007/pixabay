import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixabay/core/services/FavouritesService.dart';
import 'package:pixabay/features/Images/data/model/PixabayImage.dart';
import 'package:pixabay/features/Images/presentation/widgets/ImageGallery.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _service = FavouritesService();
  List<PixabayImage> _favourites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final favs = await _service.loadFavourites();
    if (mounted) setState(() { _favourites = favs; _loading = false; });
  }

  Future<void> _removeFavourite(PixabayImage image) async {
    await _service.toggleFavourite(image); 
    setState(() => _favourites.removeWhere((f) => f.id == image.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favourites.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border_rounded,
                          size: 72,
                          color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No favourites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap ♥ on any image to save it here',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.all(10),
                  itemCount: _favourites.length,
                  itemBuilder: (context, index) {
                    final image = _favourites[index];
                    return ImageGallery(
                      imageUrl: image.previewUrl ?? '',
                      isFavorite: true,
                      onFavorite: () => _removeFavourite(image),
                    );
                  },
                ),
    );
  }
}
