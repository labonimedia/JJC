import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  TransformationController _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),  // White back button
      ),
      backgroundColor: Colors.black,  // Black background for full-screen image
      body: GestureDetector(
        onTap: () {
          Get.back();  // Go back when the image is tapped
        },
        onDoubleTapDown: (details) {
          _doubleTapDetails = details;
        },
        onDoubleTap: () {
          if (_transformationController.value != Matrix4.identity()) {
            _transformationController.value = Matrix4.identity(); // Reset zoom
          } else {
            final position = _doubleTapDetails.localPosition;
            _transformationController.value = Matrix4.identity()
              ..translate(-position.dx * 1.5, -position.dy * 1.5)
              ..scale(3.0); // Zoom in 3x
          }
        },
        child: Center(
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,  // Minimum zoom level (can zoom out a bit)
            maxScale: 4.0,  // Maximum zoom level (can zoom in up to 4x)
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.fill, // Make the image cover the entire screen
              width: Get.width, // Match the width of the screen
              height: Get.height, // Ensure the image fits within the screen
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes!)
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }
}
