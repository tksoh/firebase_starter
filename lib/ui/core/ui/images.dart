import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseStorageImage extends StatefulWidget {
  const FirebaseStorageImage({
    super.key,
    required this.path,
    this.progressBuilder,
  });

  final String path;
  final Widget Function()? progressBuilder;

  @override
  State<FirebaseStorageImage> createState() => _FirebaseStorageImageState();
}

class _FirebaseStorageImageState extends State<FirebaseStorageImage> {
  @override
  Widget build(BuildContext context) {
    final url =
        FirebaseUrl.fromReference(FirebaseStorage.instance.ref(widget.path));

    return Image(
      image: FirebaseImageProvider(
        url,
        // options: const CacheOptions(source: Source.server),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return widget.progressBuilder?.call() ?? Container();
        }
      },
    );
  }
}
