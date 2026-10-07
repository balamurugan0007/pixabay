import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixabay/features/Images/data/bloc/ImagesEvent.dart';
import 'package:pixabay/features/Images/data/bloc/ImagesState.dart';
import 'package:pixabay/features/Images/data/model/PixabayImage.dart';
import 'package:pixabay/features/Images/domain/repository/ImagesRepository.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final ImagesRepository imagesRepository;

  ImagesBloc({required this.imagesRepository}) : super(ImagesInitial()) {
    on<FetchImagesEvent>(_fetchImages);
    on<FetchMoreImagesEvent>(_fetchMoreImages);
  }

  Future<void> _fetchImages(
    FetchImagesEvent event,
    Emitter<ImagesState> emit,
  ) async {
    emit(ImageApiLoadingState());
    try {
      final result = await imagesRepository.getImages(page: 1);
      if (result == null || result.hits.isEmpty) {
        emit(ImageApiEmptyState());
      } else {
        emit(ImageApiSuccessState(
          images: result.hits,
          page: 1,
          hasMore: result.hits.length >= 20,
        ));
      }
    } catch (e) {
      emit(ImagesApiErrorState(errMsg: e.toString()));
    }
  }

  Future<void> _fetchMoreImages(
    FetchMoreImagesEvent event,
    Emitter<ImagesState> emit,
  ) async {
  
    final current = state;
    if (current is! ImageApiSuccessState) return;
    if (!current.hasMore) return;
  
    if (current is ImageApiLoadingMoreState) return;

    final nextPage = current.page + 1;

    
    emit(ImageApiLoadingMoreState(
      images: current.images,
      page: current.page,
      hasMore: current.hasMore,
    ));

    try {
      final result = await imagesRepository.getImages(page: nextPage);
      if (result == null || result.hits.isEmpty) {
       
        emit(ImageApiSuccessState(
          images: current.images,
          page: current.page,
          hasMore: false,
        ));
      } else {
        final List<PixabayImage> merged = [...current.images, ...result.hits];
        emit(ImageApiSuccessState(
          images: merged,
          page: nextPage,
          hasMore: result.hits.length >= 20,
        ));
      }
    } catch (e) {
      
      emit(ImageApiSuccessState(
        images: current.images,
        page: current.page,
        hasMore: current.hasMore,
      ));
    }
  }
}