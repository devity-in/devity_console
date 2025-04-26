import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';

/// This [DevityImageWidget] is a equivalent to [Image] widget.
class DevityImageWidget extends StatelessWidget {
  /// Creates a [DevityImageWidget] for component view.
  /// This view is used in the component list and editor.
  const DevityImageWidget.component({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.color,
    this.opacity,
    this.type = ImageType.network,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityImageWidget] for preview view.
  /// This view is used in the preview area.
  const DevityImageWidget.preview({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.color,
    this.opacity,
    this.type = ImageType.network,
  }) : _viewType = ViewType.preview;

  /// The source of the image.
  final String source;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// How to inscribe the image into the space allocated during layout.
  final BoxFit? fit;

  /// How to align the image within its bounds.
  final AlignmentGeometry alignment;

  /// How to paint any portions of the layout bounds not covered by the image.
  final ImageRepeat repeat;

  /// The color to blend with the image.
  final Color? color;

  /// The opacity of the image.
  final double? opacity;

  /// The type of image to display.
  final ImageType type;

  /// The type of view to display.
  final ViewType _viewType;

  @override
  Widget build(BuildContext context) {
    switch (_viewType) {
      case ViewType.component:
        return _buildComponentView();
      case ViewType.preview:
        return _buildPreviewView();
    }
  }

  Widget _buildComponentView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.image, size: 16),
              const SizedBox(width: 8),
              Text(
                '${type.name.capitalize()} Image Component',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildPreviewView() {
    return _buildImage();
  }

  Widget _buildImage() {
    final image = switch (type) {
      ImageType.network => Image.network(
          source,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          color: color,
          opacity: AlwaysStoppedAnimation(opacity ?? 1.0),
        ),
      ImageType.asset => Image.asset(
          source,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          color: color,
          opacity: AlwaysStoppedAnimation(opacity ?? 1.0),
        ),
      ImageType.file => Image.file(
          source as File,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          color: color,
          opacity: AlwaysStoppedAnimation(opacity ?? 1.0),
        ),
      ImageType.memory => Image.memory(
          source as Uint8List,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          color: color,
          opacity: AlwaysStoppedAnimation(opacity ?? 1.0),
        ),
    };

    return image;
  }
}

/// Enum to track which view type to display.
enum ViewType {
  /// Component view used in the component list and editor
  component,

  /// Preview view used in the preview area
  preview,
}

/// Enum to track which type of image to display.
enum ImageType {
  /// Network image
  network,

  /// Asset image
  asset,

  /// File image
  file,

  /// Memory image
  memory,
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
