import 'package:equatable/equatable.dart';

// Enum to represent the editor's status
enum SpecEditorStatus { initial, loading, loaded, saving, error }

abstract class SpecEditorState extends Equatable {
  final SpecEditorStatus status;
  final String specId; // Keep track of the spec being edited
  final String currentContent; // The current text content in the editor
  final String? errorMessage; // Optional error message

  const SpecEditorState({
    this.status = SpecEditorStatus.initial,
    this.specId = '', // Default empty ID
    this.currentContent = '', // Default empty content
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, specId, currentContent, errorMessage];

  // Helper method to create a copy with updated values
  SpecEditorState copyWith({
    SpecEditorStatus? status,
    String? specId,
    String? currentContent,
    String? errorMessage,
    bool clearError = false, // Flag to explicitly clear the error
  }) {
    // Need a concrete implementation or factory to use copyWith effectively.
    // For now, this acts as a signature placeholder.
    // You'll typically implement this in concrete state classes.
    throw UnimplementedError(
        'copyWith must be implemented in concrete state classes');
  }
}

class SpecEditorInitial extends SpecEditorState {
  const SpecEditorInitial() : super(status: SpecEditorStatus.initial);
}

// Example concrete state extending the base
class SpecEditorConcreteState extends SpecEditorState {
  const SpecEditorConcreteState({
    super.status,
    super.specId,
    super.currentContent,
    super.errorMessage,
  });

  @override
  SpecEditorConcreteState copyWith({
    SpecEditorStatus? status,
    String? specId,
    String? currentContent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SpecEditorConcreteState(
      status: status ?? this.status,
      specId: specId ?? this.specId,
      currentContent: currentContent ?? this.currentContent,
      // If clearError is true, set errorMessage to null,
      // otherwise update with provided message or keep existing.
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}


// --- We could define specific states for loading, loaded, error etc. ---
// --- OR use the single SpecEditorConcreteState with different status values. ---
// --- Using a single state class with `copyWith` is often more flexible. ---

// Example using specific states (alternative approach):
/*
class SpecEditorLoading extends SpecEditorState {
  const SpecEditorLoading({required String specId}) : super(status: SpecEditorStatus.loading, specId: specId);
}

class SpecEditorLoaded extends SpecEditorState {
  const SpecEditorLoaded({required String specId, required String initialContent}) 
      : super(status: SpecEditorStatus.loaded, specId: specId, currentContent: initialContent);
}

class SpecEditorSaving extends SpecEditorState {
   const SpecEditorSaving({required String specId, required String contentToSave}) 
      : super(status: SpecEditorStatus.saving, specId: specId, currentContent: contentToSave);
}

class SpecEditorError extends SpecEditorState {
  const SpecEditorError({required String specId, required String content, required String message}) 
      : super(status: SpecEditorStatus.error, specId: specId, currentContent: content, errorMessage: message);
}
*/ 