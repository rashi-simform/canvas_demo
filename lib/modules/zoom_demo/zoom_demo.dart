import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class CanvasImageZoomScreen extends StatefulWidget {
  const CanvasImageZoomScreen({super.key});

  @override
  CanvasImageZoomScreenState createState() => CanvasImageZoomScreenState();
}

class CanvasImageZoomScreenState extends State<CanvasImageZoomScreen> {
  bool _showMagnifier = false;
  Offset _magnifierPosition = Offset.zero;
  final double _magnifierSize = 60.0;
  final double _zoomFactor = 2.0;
  final double _zoomViewHeight = 150.0;
  ui.Image? _image;
  bool _isImageLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      // Create an asset image
      final ImageProvider imageProvider = AssetImage(
        'assets/images/post1.jpeg',
      );

      // Load the image
      final ImageStream stream = imageProvider.resolve(ImageConfiguration());

      final Completer<ui.Image> completer = Completer<ui.Image>();

      final ImageStreamListener listener = ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image);
        },
        onError: (dynamic exception, StackTrace? stackTrace) {
          completer.completeError(exception);
        },
      );

      stream.addListener(listener);

      // Wait for image to load
      final ui.Image image = await completer.future;

      setState(() {
        _image = image;
        _isImageLoading = false;

        // Set initial magnifier position to the center when image is loaded
        if (_magnifierPosition == Offset.zero) {
          _magnifierPosition = Offset(
            MediaQuery.of(context).size.width / 2,
            (MediaQuery.of(context).size.height - _zoomViewHeight) / 2,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isImageLoading = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canvas Image Zoom'),
        actions: [
          IconButton(
            icon: Icon(_showMagnifier ? Icons.zoom_out : Icons.zoom_in),
            onPressed: () {
              setState(() {
                _showMagnifier = !_showMagnifier;
                if (!_showMagnifier) {
                  // Reset position when turning off
                  _magnifierPosition = Offset.zero;
                } else if (_magnifierPosition == Offset.zero) {
                  // Set to center of image when first turning on
                  _magnifierPosition = Offset(
                    MediaQuery.of(context).size.width / 2,
                    (MediaQuery.of(context).size.height - _zoomViewHeight) / 2,
                  );
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main canvas area
          _buildMainCanvas(),

          // Magnifier icon (conditionally shown)
          if (_showMagnifier && _image != null) _buildMagnifierIcon(),

          // Zoom view panel at bottom
          if (_showMagnifier && _image != null) _buildZoomView(),
        ],
      ),
    );
  }

  Widget _buildMainCanvas() {
    if (_isImageLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null) {
      return Center(child: Text('Failed to load image: $_loadError'));
    }

    if (_image == null) {
      return const Center(child: Text('No image available'));
    }

    return GestureDetector(
      onPanUpdate:
          _showMagnifier
              ? (details) {
                setState(() {
                  // Update magnifier position when dragging
                  _magnifierPosition += details.delta;

                  // Constrain to bounds of the screen
                  _magnifierPosition = Offset(
                    _magnifierPosition.dx.clamp(
                      0,
                      MediaQuery.of(context).size.width,
                    ),
                    _magnifierPosition.dy.clamp(
                      0,
                      MediaQuery.of(context).size.height - _zoomViewHeight - 50,
                    ),
                  );
                });
              }
              : null,
      child: CustomPaint(
        painter: ImagePainter(_image!),
        size: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height - _zoomViewHeight,
        ),
      ),
    );
  }

  Widget _buildMagnifierIcon() {
    return Positioned(
      left: _magnifierPosition.dx - _magnifierSize / 2,
      top: _magnifierPosition.dy - _magnifierSize / 2,
      child: Container(
        width: _magnifierSize,
        height: _magnifierSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 2),
          color: Colors.blue.withOpacity(0.2),
        ),
        child: const Icon(Icons.search, color: Colors.blue),
      ),
    );
  }

  Widget _buildZoomView() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: _zoomViewHeight,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: CustomPaint(
          painter: ZoomedImagePainter(
            image: _image!,
            focalPoint: _magnifierPosition,
            zoomFactor: _zoomFactor,
            viewSize: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height - _zoomViewHeight,
            ),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Zoomed View',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Calculate scaling to fit image within view while maintaining aspect ratio
    final double imageAspectRatio = image.width / image.height;
    final double screenAspectRatio = size.width / size.height;

    double targetWidth, targetHeight;

    if (imageAspectRatio > screenAspectRatio) {
      // Image is wider than screen
      targetWidth = size.width;
      targetHeight = size.width / imageAspectRatio;
    } else {
      // Image is taller than screen
      targetHeight = size.height;
      targetWidth = size.height * imageAspectRatio;
    }

    // Calculate position to center the image
    final double left = (size.width - targetWidth) / 2;
    final double top = (size.height - targetHeight) / 2;

    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromLTWH(left, top, targetWidth, targetHeight);

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ZoomedImagePainter extends CustomPainter {
  final ui.Image image;
  final Offset focalPoint;
  final double zoomFactor;
  final Size viewSize;

  ZoomedImagePainter({
    required this.image,
    required this.focalPoint,
    required this.zoomFactor,
    required this.viewSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Calculate the image's displayed dimensions in the main view
    final double imageAspectRatio = image.width / image.height;
    final double screenAspectRatio = viewSize.width / viewSize.height;

    double mainImageWidth, mainImageHeight;
    double mainImageLeft, mainImageTop;

    if (imageAspectRatio > screenAspectRatio) {
      // Image is wider than screen
      mainImageWidth = viewSize.width;
      mainImageHeight = viewSize.width / imageAspectRatio;
      mainImageLeft = 0;
      mainImageTop = (viewSize.height - mainImageHeight) / 2;
    } else {
      // Image is taller than screen
      mainImageHeight = viewSize.height;
      mainImageWidth = viewSize.height * imageAspectRatio;
      mainImageLeft = (viewSize.width - mainImageWidth) / 2;
      mainImageTop = 0;
    }

    // Calculate the area to zoom in on
    final Rect displayedImageRect = Rect.fromLTWH(
      mainImageLeft,
      mainImageTop,
      mainImageWidth,
      mainImageHeight,
    );

    // Check if focal point is within the displayed image
    if (!displayedImageRect.contains(focalPoint)) {
      // If focal point is outside the image, just show the whole image
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black,
      );
      return;
    }

    // Calculate relative position within the displayed image (0-1 range)
    final double relativeX =
        (focalPoint.dx - displayedImageRect.left) / displayedImageRect.width;
    final double relativeY =
        (focalPoint.dy - displayedImageRect.top) / displayedImageRect.height;

    // Calculate source rectangle from the original image
    final double zoomViewWidth = size.width / zoomFactor;
    final double zoomViewHeight = size.height / zoomFactor;

    // Calculate the area around the focal point
    final double sourceWidth = image.width * (zoomViewWidth / mainImageWidth);
    final double sourceHeight =
        image.height * (zoomViewHeight / mainImageHeight);

    // Center the source rect on the relative position
    final double sourceLeft = (image.width * relativeX) - (sourceWidth / 2);
    final double sourceTop = (image.height * relativeY) - (sourceHeight / 2);

    // Create source and destination rectangles
    Rect src = Rect.fromLTWH(
      sourceLeft.clamp(0, image.width - sourceWidth),
      sourceTop.clamp(0, image.height - sourceHeight),
      sourceWidth,
      sourceHeight,
    );

    Rect dst = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the zoomed image
    canvas.drawImageRect(image, src, dst, paint);

    // Draw a border around the zoom view
    final borderPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
