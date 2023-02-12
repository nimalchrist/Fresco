import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget {
  final String imageURL;
  const ImageViewer({super.key, required this.imageURL});

  @override
  State<ImageViewer> createState() => _ImageViewerState(this.imageURL);
}

class _ImageViewerState extends State<ImageViewer> {
  final String imageURL;
  _ImageViewerState(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: PhotoView(
              maxScale: 0.5,
              imageProvider: NetworkImage(
                imageURL,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
