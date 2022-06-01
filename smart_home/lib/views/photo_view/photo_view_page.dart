import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewRouteWrapper extends StatelessWidget {
  const PhotoViewRouteWrapper({
    this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.tag,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: [
            PhotoView(
              imageProvider: imageProvider,
              backgroundDecoration: backgroundDecoration,
              minScale: minScale,
              maxScale: maxScale,
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}