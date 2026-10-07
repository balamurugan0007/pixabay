import 'package:pixabay/features/Images/data/model/PixabayImage.dart';

class PixabayResponse {
  final int total;
  final int totalHits;
  final List<PixabayImage> hits;

  const PixabayResponse({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  factory PixabayResponse.fromJson(Map<String, dynamic> json) {
    return PixabayResponse(
      total: json['total'],
      totalHits: json['totalHits'],
      hits: (json['hits'] as List)
          .map((item) => PixabayImage.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'totalHits': totalHits,
      'hits': hits.map((item) => item.toJson()).toList(),
    };
  }
}
