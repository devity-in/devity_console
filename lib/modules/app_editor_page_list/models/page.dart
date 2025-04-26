/// Model class for a page.
class Page {
  /// Creates a new instance of [Page].
  const Page({
    required this.id,
    required this.name,
    this.description,
  });

  /// The unique identifier of the page.
  final String id;

  /// The name of the page.
  final String name;

  /// The description of the page.
  final String? description;
}
