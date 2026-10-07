import 'package:pixabay/features/Images/data/model/PixabayImage.dart';

abstract class ImagesState {}

class ImagesInitial extends ImagesState {}


final class ImageApiLoadingState extends ImagesState {}


final class ImageApiLoadingMoreState extends ImageApiSuccessState {
  ImageApiLoadingMoreState({
    required super.images,
    required super.page,
    required super.hasMore,
  });
}

final class ImagesApiErrorState extends ImagesState {
  final String errMsg;
  ImagesApiErrorState({required this.errMsg});
}

final class ImageApiSuccessState extends ImagesState {
  final List<PixabayImage> images;
  final int page;
  final bool hasMore;

  ImageApiSuccessState({
    required this.images,
    required this.page,
    required this.hasMore,
  });
}

final class ImageApiEmptyState extends ImagesState {}
