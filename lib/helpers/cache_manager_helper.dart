import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheManagerHelper {
  /// Download and overwrite a list of images to the cache
  static Future<void> replaceImagesOnCacheManager(List<String> imageUrls, {CacheManager? cacheManager}) async {
    CacheManager cacheManagerToUse = cacheManager ?? DefaultCacheManager();
    List<Future> futures = <Future>[];
    for (String url in imageUrls) {
      futures.add(cacheManagerToUse.downloadFile(url, force: true, key: url));
    }
    await Future.wait(futures);
    await removeImagesFromCachedNetworkImageProvider(imageUrls);
  }

  /// Evict a list of images from the CachedNetworkImageProvider
  static Future<void> removeImagesFromCachedNetworkImageProvider(List<String> imageUrls,
      {CacheManager? cacheManager}) async {
    List<Future> futures = <Future>[];
    for (String url in imageUrls) {
      futures.add(CachedNetworkImageProvider(url).evict());
    }
    await Future.wait(futures);
  }
}
