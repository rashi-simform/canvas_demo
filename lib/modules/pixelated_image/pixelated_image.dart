import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PixelatedImage extends StatefulWidget {
  const PixelatedImage({Key? key}) : super(key: key);

  @override
  State<PixelatedImage> createState() => _PixelatedImageState();
}

class _PixelatedImageState extends State<PixelatedImage> {
  ui.Image? _originalImage;
  List<Color>? _imageColors;
  bool _isLoading = true;
  double _pixelSize = 8.0;

  final String assetPath = 'assets/images/post1.jpeg';

  @override
  void initState() {
    super.initState();
    _loadAssetImage();
  }

  Future<void> _loadAssetImage() async {
    try {
      // Load the asset as bytes
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      // Extract all pixel colors from the image
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (byteData != null) {
        final int width = image.width;
        final int height = image.height;
        final List<Color> colors = List.generate(width * height, (index) {
          final int x = index % width;
          final int y = index ~/ width;
          final int position = (y * width + x) * 4;

          return Color.fromARGB(
            byteData.getUint8(position + 3),
            byteData.getUint8(position),
            byteData.getUint8(position + 1),
            byteData.getUint8(position + 2),
          );
        });

        setState(() {
          _originalImage = image;
          _imageColors = colors;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to extract image data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading or processing image: $e');
    }
  }

  Color _getPixelColor(int x, int y) {
    if (_originalImage == null || _imageColors == null) {
      return Colors.transparent;
    }

    final int width = _originalImage!.width;
    final int index =
        y.clamp(0, _originalImage!.height - 1) * width + x.clamp(0, width - 1);
    return _imageColors![index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Image Pixelation'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _originalImage == null
              ? const Center(child: Text('Failed to load image'))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Original Image
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: Image.asset(
                    //     assetPath,
                    //     height: 100,
                    //     width: double.infinity,
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          'Pixel Size:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _pixelSize,
                            min: 1.0,
                            max: 50.0,
                            divisions: 49,
                            label: _pixelSize.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                _pixelSize = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          '${_pixelSize.round()}px',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pixelated Image',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: CustomPaint(
                              painter: EffectivePixelationPainter(
                                image: _originalImage!,
                                pixelSize: _pixelSize.round(),
                                getPixelColor: _getPixelColor,
                              ),
                              size: Size(
                                _originalImage!.width.toDouble(),
                                _originalImage!.height.toDouble(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

class EffectivePixelationPainter extends CustomPainter {
  final ui.Image image;
  final int pixelSize;
  final Color Function(int x, int y) getPixelColor;

  EffectivePixelationPainter({
    required this.image,
    required this.pixelSize,
    required this.getPixelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..isAntiAlias = false
          ..filterQuality = FilterQuality.none;

    // Calculate scaling to fit the canvas
    final double scaleX = size.width / image.width;
    final double scaleY = size.height / image.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    // Calculate centered position
    final double offsetX = (size.width - (image.width * scale)) / 2;
    final double offsetY = (size.height - (image.height * scale)) / 2;

    // Apply scaling transform
    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(0.07);

    // Draw pixelated version
    for (int y = 0; y < image.height; y += pixelSize) {
      for (int x = 0; x < image.width; x += pixelSize) {
        // Get a representative color for this block
        final Color blockColor = _getAverageColor(x, y);

        // Draw the pixel block
        paint.color = blockColor;
        final Rect rect = Rect.fromLTWH(
          x.toDouble(),
          y.toDouble(),
          pixelSize.toDouble(),
          pixelSize.toDouble(),
        );
        canvas.drawRect(rect, paint);
      }
    }

    canvas.restore();
  }

  Color _getAverageColor(int startX, int startY) {
    // For small pixel sizes, just sample the center point
    if (pixelSize <= 3) {
      return getPixelColor(startX, startY);
    }

    // For larger pixel sizes, average multiple sample points
    int r = 0, g = 0, b = 0, a = 0;
    int sampleCount = 0;

    // Take up to 9 samples within the block
    final int sampleStep = pixelSize ~/ 3;
    for (int y = 0; y < pixelSize; y += sampleStep) {
      for (int x = 0; x < pixelSize; x += sampleStep) {
        final int sampleX = startX + x;
        final int sampleY = startY + y;

        // Skip if out of bounds
        if (sampleX >= image.width || sampleY >= image.height) continue;

        final Color color = getPixelColor(sampleX, sampleY);
        r += color.red;
        g += color.green;
        b += color.blue;
        a += color.alpha;
        sampleCount++;
      }
    }

    if (sampleCount == 0) return getPixelColor(startX, startY);

    return Color.fromARGB(
      (a / sampleCount).round(),
      (r / sampleCount).round(),
      (g / sampleCount).round(),
      (b / sampleCount).round(),
    );
  }

  @override
  bool shouldRepaint(covariant EffectivePixelationPainter oldPainter) {
    return oldPainter.image != image || oldPainter.pixelSize != pixelSize;
  }
}
