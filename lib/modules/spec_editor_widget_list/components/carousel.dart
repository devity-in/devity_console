import 'package:flutter/material.dart';

/// This [DevityCarouselWidget] is a equivalent to [PageView] widget with additional features.
class DevityCarouselWidget extends StatelessWidget {
  /// Creates a [DevityCarouselWidget] for component view.
  /// This view is used in the component list and editor.
  const DevityCarouselWidget.component({
    super.key,
    required this.items,
    this.height = 200,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnTouch = true,
    this.enlargeCenterPage = false,
    this.scrollDirection = Axis.horizontal,
    this.onPageChanged,
    this.type = CarouselType.standard,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityCarouselWidget] for preview view.
  /// This view is used in the preview area.
  const DevityCarouselWidget.preview({
    super.key,
    required this.items,
    this.height = 200,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnTouch = true,
    this.enlargeCenterPage = false,
    this.scrollDirection = Axis.horizontal,
    this.onPageChanged,
    this.type = CarouselType.standard,
  }) : _viewType = ViewType.preview;

  /// The items to display in the carousel.
  final List<Widget> items;

  /// The height of the carousel.
  final double height;

  /// The aspect ratio of the carousel.
  final double aspectRatio;

  /// The fraction of the viewport that each page should occupy.
  final double viewportFraction;

  /// The page to show when first creating the carousel.
  final int initialPage;

  /// Whether to enable infinite scroll.
  final bool enableInfiniteScroll;

  /// Whether to reverse the scroll direction.
  final bool reverse;

  /// Whether to enable auto play.
  final bool autoPlay;

  /// The interval between auto play transitions.
  final Duration autoPlayInterval;

  /// The duration of the auto play animation.
  final Duration autoPlayAnimationDuration;

  /// The curve to use for auto play animation.
  final Curve autoPlayCurve;

  /// Whether to pause auto play on touch.
  final bool pauseAutoPlayOnTouch;

  /// Whether to enlarge the center page.
  final bool enlargeCenterPage;

  /// The direction in which the carousel scrolls.
  final Axis scrollDirection;

  /// Called when the page changes.
  final ValueChanged<int>? onPageChanged;

  /// The type of carousel to display.
  final CarouselType type;

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
              const Icon(Icons.view_carousel, size: 16),
              const SizedBox(width: 8),
              Text(
                '${type.name.capitalize()} Carousel Component',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildCarousel(),
        ],
      ),
    );
  }

  Widget _buildPreviewView() {
    return _buildCarousel();
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: height,
      child: PageView.builder(
        itemCount: enableInfiniteScroll ? null : items.length,
        controller: PageController(
          viewportFraction: viewportFraction,
          initialPage: initialPage,
        ),
        reverse: reverse,
        scrollDirection: scrollDirection,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) {
          final itemIndex = index % items.length;
          return _buildCarouselItem(items[itemIndex]);
        },
      ),
    );
  }

  Widget _buildCarouselItem(Widget item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item,
      ),
    );
  }
}

/// Enum to track which view type to display.
enum ViewType {
  /// Component view used in the component list and editor
  component,

  /// Preview view used in the preview area
  preview,
}

/// Enum to track which type of carousel to display.
enum CarouselType {
  /// Standard carousel
  standard,

  /// Card carousel
  card,

  /// Full screen carousel
  fullScreen,

  /// Custom carousel
  custom,
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
