import 'package:devity_console/modules/app_editor_page_list/bloc/app_editor_page_list_event.dart';
import 'package:devity_console/modules/app_editor_page_list/bloc/app_editor_page_list_state.dart';
import 'package:devity_console/modules/app_editor_page_list/models/page.dart'
    as models;
import 'package:flutter_bloc/flutter_bloc.dart';

/// [AppEditorPageListBloc] is a business logic component that manages the state of the
/// app editor page list.
class AppEditorPageListBloc
    extends Bloc<AppEditorPageListEvent, AppEditorPageListState> {
  /// Creates a new instance of [AppEditorPageListBloc].
  AppEditorPageListBloc() : super(const AppEditorPageListInitialState()) {
    on<AppEditorPageListStartedEvent>(_onStarted);
    on<AppEditorPageListAddPageEvent>(_onAddPage);
    on<AppEditorPageListUpdatePageEvent>(_onUpdatePage);
    on<AppEditorPageListDeletePageEvent>(_onDeletePage);
    on<AppEditorPageListSearchEvent>(_onSearch);
  }

  /// List of all pages
  List<models.Page> _allPages = [];

  Future<void> _onStarted(
    AppEditorPageListStartedEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    emit(const AppEditorPageListLoadingState());
    try {
      // TODO: Implement API call to get pages
      _allPages = [
        const models.Page(
          id: '1',
          name: 'Home Page',
          description: 'The main landing page of the application',
        ),
        const models.Page(
          id: '2',
          name: 'About Us',
          description: 'Information about our company and team',
        ),
        const models.Page(
          id: '3',
          name: 'Contact',
          description: 'Ways to get in touch with us',
        ),
        const models.Page(
          id: '4',
          name: 'Products',
          description: 'Our product catalog and offerings',
        ),
        const models.Page(
          id: '5',
          name: 'Services',
          description: 'Services we provide to our customers',
        ),
      ];
      emit(AppEditorPageListLoadedState(pages: _allPages));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: e.toString()));
    }
  }

  Future<void> _onAddPage(
    AppEditorPageListAddPageEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    try {
      // TODO: Implement API call to create page
      final page = models.Page(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: event.name,
        description: event.description,
      );
      _allPages = [..._allPages, page];
      emit(AppEditorPageListLoadedState(pages: _allPages));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdatePage(
    AppEditorPageListUpdatePageEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    try {
      // TODO: Implement API call to update page
      _allPages = _allPages.map((page) {
        if (page.id == event.id) {
          return models.Page(
            id: page.id,
            name: event.name,
            description: event.description,
          );
        }
        return page;
      }).toList();
      emit(AppEditorPageListLoadedState(pages: _allPages));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeletePage(
    AppEditorPageListDeletePageEvent event,
    Emitter<AppEditorPageListState> emit,
  ) async {
    try {
      // TODO: Implement API call to delete page
      _allPages = _allPages.where((page) => page.id != event.pageId).toList();
      emit(AppEditorPageListLoadedState(pages: _allPages));
    } catch (e) {
      emit(AppEditorPageListErrorState(message: e.toString()));
    }
  }

  void _onSearch(
    AppEditorPageListSearchEvent event,
    Emitter<AppEditorPageListState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(AppEditorPageListLoadedState(pages: _allPages));
      return;
    }

    final query = event.query.toLowerCase();
    final filteredPages = _allPages.where((page) {
      final nameMatch = page.name.toLowerCase().contains(query);
      final descriptionMatch =
          page.description?.toLowerCase().contains(query) ?? false;
      return nameMatch || descriptionMatch;
    }).toList();

    emit(AppEditorPageListLoadedState(pages: filteredPages));
  }
}

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
