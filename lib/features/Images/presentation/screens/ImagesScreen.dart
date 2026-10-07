import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixabay/core/network/Services/ImageDownloadServices.dart';
import 'package:pixabay/core/services/FavouritesService.dart';
import 'package:pixabay/features/Images/data/bloc/ImagesBloc.dart';
import 'package:pixabay/features/Images/data/bloc/ImagesEvent.dart';
import 'package:pixabay/features/Images/data/bloc/ImagesState.dart';
import 'package:pixabay/features/Images/data/model/PixabayImage.dart';
import 'package:pixabay/features/Images/presentation/screens/FavouritesScreen.dart';
import 'package:pixabay/features/Images/presentation/widgets/ImageGallery.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({super.key});

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final ScrollController _scrollController = ScrollController();
  final FavouritesService _favouritesService = FavouritesService();

  final Set<int> _favouriteIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadFavouriteIds();
  }

  Future<void> _loadFavouriteIds() async {
    final favs = await _favouritesService.loadFavourites();
    if (mounted) {
      setState(() {
        _favouriteIds.addAll(favs.map((f) => f.id ?? -1));
      });
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<ImagesBloc>().add(FetchMoreImagesEvent());
    }
  }

  Future<void> _toggleFavourite(PixabayImage image) async {
    final id = image.id ?? -1;
    final alreadyFav = _favouriteIds.contains(id);
    setState(() {
      if (alreadyFav) {
        _favouriteIds.remove(id);
      } else {
        _favouriteIds.add(id);
      }
    });

    try {
      await _favouritesService.toggleFavourite(image);
    } catch (_) {
   
      if (mounted) {
        setState(() {
          if (alreadyFav) {
            _favouriteIds.add(id);
          } else {
            _favouriteIds.remove(id);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favourites')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Pixabay',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavouritesScreen()),
              );
            },
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (context, state) {
          if (state is ImageApiLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ImageApiEmptyState) {
            return const Center(child: Text('No Images'));
          }

          if (state is ImagesApiErrorState) {
            return Center(child: Text(state.errMsg));
          }

          if (state is ImageApiSuccessState) {
            final List<PixabayImage> images = state.images;
            final bool isLoadingMore = state is ImageApiLoadingMoreState;

            return MasonryGridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(10),
              itemCount: images.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == images.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final image = images[index];
                final isFav = _favouriteIds.contains(image.id ?? -1);

                return ImageGallery(
                  imageUrl: image.previewUrl ?? '',
                  isFavorite: isFav,

                  onTap: () {
                   
                  },

                  onFavorite: () => _toggleFavourite(image),

                  onDownload: () => ImageDownloadServices().downloadImage(
                    image.webformatUrl ?? image.previewUrl ?? '',
                    image.photoName ?? 'pixabay_${image.id ?? 0}',
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
