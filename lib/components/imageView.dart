import 'package:flutter/material.dart';

class ImageViewComponent extends StatefulWidget {
  final String image;
  final double? height;
  final double? width;

  const ImageViewComponent({
    Key? key,
    required this.image,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  _ImageViewComponentState createState() => _ImageViewComponentState();
}

class _ImageViewComponentState extends State<ImageViewComponent> {
  final _transformationController = TransformationController();
  late TapDownDetails _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: widget.height != null ? widget.height : 200,
          child: GestureDetector(
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(100.0),
              minScale: 0.1,
              maxScale: 2,
              child: Image.network(
                widget.image,
                fit: BoxFit.contain,
              ),
            ),
          )),
    );
  }
}
