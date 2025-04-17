import 'package:flutter/material.dart';

/// A widget that displays its children in a horizontal scrollable carousel.
class DevityCarouselLayout extends StatelessWidget {
  /// Creates a [DevityCarouselLayout] for component view.
  const DevityCarouselLayout.component({
    super.key,
    required this.children,
    this.height = 200.0,
    this.viewportFraction = 1.0,
    this.initialPage = 0,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.onPageChanged,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.pageSnapping = true,
    this.scrollPhysics,
    this.padEnds = true,
  }) : _viewType = ViewType.component;

  /// Creates a [DevityCarouselLayout] for preview view.
  const DevityCarouselLayout.preview({
    super.key,
    required this.children,
    this.height = 200.0,
    this.viewportFraction = 1.0,
    this.initialPage = 0,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.onPageChanged,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.pageSnapping = true,
    this.scrollPhysics,
    this.padEnds = true,
  }) : _viewType = ViewType.preview;

  /// The widgets to display in the carousel.
  final List<Widget> children;

  /// The height of the carousel.
  final double height;

  /// The fraction of the viewport that each page should occupy.
  final double viewportFraction;

  /// The initial page to show.
  final int initialPage;

  /// Whether the carousel should loop infinitely.
  final bool enableInfiniteScroll;

  /// Whether the carousel should automatically transition between pages.
  final bool autoPlay;

  /// The time between automatic page transitions.
  final Duration autoPlayInterval;

  /// The duration of the animation when automatically transitioning between pages.
  final Duration autoPlayAnimationDuration;

  /// The curve to use when automatically transitioning between pages.
  final Curve autoPlayCurve;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int>? onPageChanged;

  /// The axis along which the page view scrolls.
  final Axis scrollDirection;

  /// Whether to reverse the order of the items.
  final bool reverse;

  /// Whether the page view should snap to page boundaries.
  final bool pageSnapping;

  /// How the page view should respond to user input.
  final ScrollPhysics? scrollPhysics;

  /// Whether to add padding to both ends of the list.
  final bool padEnds;

  /// The type of view to display.
  final ViewType _viewType;

  @override
  Widget build(BuildContext context) {
    switch (_viewType) {
      case ViewType.component:
        return _buildComponentView(context);
      case ViewType.preview:
        return _buildPreviewView(context);
    }
  }

  Widget _buildComponentView(BuildContext context) {
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
                'Carousel Layout',
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

  Widget _buildPreviewView(BuildContext context) {
    return _buildCarousel();
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: height,
      child: PageView.builder(
        itemCount: enableInfiniteScroll ? null : children.length,
        controller: PageController(
          initialPage: initialPage,
          viewportFraction: viewportFraction,
        ),
        onPageChanged: onPageChanged,
        scrollDirection: scrollDirection,
        reverse: reverse,
        physics: scrollPhysics,
        pageSnapping: pageSnapping,
        padEnds: padEnds,
        itemBuilder: (context, index) {
          final effectiveIndex =
              enableInfiniteScroll ? index % children.length : index;
          return children[effectiveIndex];
        },
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
