import '/services/similarity.dart';
import 'package:flutter/material.dart';

class CarouselImage extends StatefulWidget {
  final String? label;
  final String url;
  final Function(bool) zoom_update;
  const CarouselImage({
    super.key,
    required this.zoom_update,
    required this.url,
    this.label,
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  @override
  final TransformationController controller = TransformationController();
  bool _isZoomed = false;
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: controller,
      onInteractionUpdate: (ScaleUpdateDetails details) {
        final double scale = controller.value.getMaxScaleOnAxis();

        if (scale > 1.0 && !_isZoomed) {
          setState(() {
            _isZoomed = true;
            widget.zoom_update(_isZoomed);
          });
        } else if (scale <= 1.0 && _isZoomed) {
          setState(() {
            _isZoomed = false;
            widget.zoom_update(_isZoomed);
          });
        }
      },
      child: Column(
        children: [
          if (widget.label != null) ...[
            Text(
              textAlign: TextAlign.center,
              widget.label ?? "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
          ],

          Expanded(
            child: Center(
              child: Image.network(
                widget.url,
                fit: BoxFit.contain,

                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (frame == null) {
                    return Container(
                      child: const Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            color: Color.fromARGB(255, 9, 8, 50),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    child: child,
                    foregroundDecoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.black),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    child: Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          color: const Color.fromARGB(255, 9, 8, 50),
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
