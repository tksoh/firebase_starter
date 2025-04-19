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
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return Image(
        image: NetworkImage(imageUrl),
      );
    } else {
      return widget.progressBuilder?.call() ?? Container();
    }
  }

  Future<void> getImage() async {
    final ref = storage.ref().child(widget.path);
    imageUrl = await ref.getDownloadURL();
    setState(() {});
  }
}
