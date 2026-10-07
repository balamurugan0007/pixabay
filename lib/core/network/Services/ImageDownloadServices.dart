
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:pixabay/core/network/api/base_api.dart';

class ImageDownloadServices {

  Future<void> downloadImage(String url, String name) async {
    final Uint8List? bytes = await BaseApi().getRawBytes(url);
    if (bytes == null) {
      throw Exception('Failed to fetch image bytes');
    }

    final hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      final access = await Gal.requestAccess();
      if (!access) {
        throw Exception('Gallery permission denied');
      }
    }

    await Gal.putImageBytes(bytes, name: name);
  }
}