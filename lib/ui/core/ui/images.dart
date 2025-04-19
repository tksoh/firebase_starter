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
  final storage = FirebaseStorage.instance;
  NetworkImage? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: FirebaseImageProvider(
        FirebaseUrl.fromReference(FirebaseStorage.instance.ref(widget.path)),
        options: const CacheOptions(source: Source.server),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        return widget.progressBuilder?.call() ?? Container();
      },
    );
  }

  Future<void> getImage() async {
    final ref = storage.ref().child(widget.path);
    final imageUrl = await ref.getDownloadURL();

    if (!mounted) return;
    image = NetworkImage(imageUrl);
    await precacheImage(image!, context);

    setState(() {});
  }
}
