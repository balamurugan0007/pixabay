class PixabayImage {
  final int? id;
  final String? pageUrl;
  final String? type;
  final String? tags;
  final String? previewUrl;
  final int? previewWidth;
  final int? previewHeight;
  final String? webformatUrl;
  final int? webformatWidth;
  final int? webformatHeight;
  final String largeImageUrl;
  final String? fullHdUrl;
  final String? imageUrl;
  final int? imageWidth;
  final int? imageHeight;
  final int? imageSize;
  final int? views;
  final int? downloads;
  final int? likes;
  final int? comments;
  final int? userId;
  final String? user;
  final String? userImageUrl;
  final String? photoName;

  const PixabayImage({
    this.id,
    this.pageUrl,
    this.type,
    this.tags,
    this.previewUrl,
    this.previewWidth,
    this.previewHeight,
    this.webformatUrl,
    this.webformatWidth,
    this.webformatHeight,
    required this.largeImageUrl,
    this.fullHdUrl,
    this.imageUrl,
    this.imageWidth,
    this.imageHeight,
    this.imageSize,
    this.views,
    this.downloads,
    this.likes,
    this.comments,
    this.userId,
    this.user,
    this.userImageUrl,
    this.photoName,
  });


  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    return PixabayImage(
      id: json['id'],
      pageUrl: json['pageURL'],
      type: json['type'],
      tags: json['tags'],
      previewUrl: json['previewURL'],
      previewWidth: json['previewWidth'],
      previewHeight: json['previewHeight'],
      webformatUrl: json['webformatURL'],
      webformatWidth: json['webformatWidth'],
      webformatHeight: json['webformatHeight'],
      largeImageUrl: json['largeImageURL'] ?? '',
      fullHdUrl: json['fullHDURL'],
      imageUrl: json['imageURL'],
      imageWidth: json['imageWidth'],
      imageHeight: json['imageHeight'],
      imageSize: json['imageSize'],
      views: json['views'],
      downloads: json['downloads'],
      likes: json['likes'],
      comments: json['comments'],
      userId: json['user_id'],
      user: json['user'],
      userImageUrl: json['userImageURL'],
      photoName: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageURL': pageUrl,
      'type': type,
      'tags': tags,
      'previewURL': previewUrl,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatUrl,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageUrl,
      'fullHDURL': fullHdUrl,
      'imageURL': imageUrl,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'likes': likes,
      'comments': comments,
      'user_id': userId,
      'user': user,
      'userImageURL': userImageUrl,
      'name': photoName,
    };
  }
}