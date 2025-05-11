import 'package:flutter/material.dart';

enum ActionType { navigate, showAlert } // Enum to manage type selection

class AddEditActionDialog extends StatefulWidget {
  const AddEditActionDialog({
    super.key,
    this.existingActionId,
    this.existingActionData,
  });
  // Pass existing action data if editing, null if adding
  final String? existingActionId;
  final Map<String, dynamic>? existingActionData;

  @override
  State<AddEditActionDialog> createState() => _AddEditActionDialogState();
}

class _AddEditActionDialogState extends State<AddEditActionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _actionIdController;
  ActionType _selectedActionType = ActionType.navigate; // Default

  // Controllers for attributes
  late TextEditingController _navigateTargetIdController;
  late TextEditingController _alertTitleController;
  late TextEditingController _alertMessageController;
  late TextEditingController _alertButtonTextController;

  bool get _isEditing => widget.existingActionId != null;

  @override
  void initState() {
    super.initState();

    final data = widget.existingActionData ?? {};
    final typeString = data['actionType'] as String?;
    _selectedActionType = _getActionTypeFromString(typeString);

    _actionIdController =
        TextEditingController(text: widget.existingActionId ?? '');

    final attributes = data['attributes'] as Map<String, dynamic>? ?? {};
    // Explicitly cast attributes when initializing controllers
    _navigateTargetIdController = TextEditingController(
      text: attributes['targetScreenId'] as String? ?? '',
    );
    _alertTitleController =
        TextEditingController(text: attributes['title'] as String? ?? '');
    _alertMessageController =
        TextEditingController(text: attributes['message'] as String? ?? '');
    _alertButtonTextController =
        TextEditingController(text: attributes['buttonText'] as String? ?? '');
  }

  ActionType _getActionTypeFromString(String? typeString) {
    switch (typeString) {
      case 'Navigate':
        return ActionType.navigate;
      case 'ShowAlert':
        return ActionType.showAlert;
      default:
        return ActionType.navigate; // Default if unknown or new
    }
  }

  String _getActionTypeString(ActionType type) {
    switch (type) {
      case ActionType.navigate:
        return 'Navigate';
      case ActionType.showAlert:
        return 'ShowAlert';
    }
  }

  @override
  void dispose() {
    _actionIdController.dispose();
    _navigateTargetIdController.dispose();
    _alertTitleController.dispose();
    _alertMessageController.dispose();
    _alertButtonTextController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final actionId = _actionIdController.text.trim();
      // The validator for _actionIdController already checks for empty.
      // No need for: if (actionId.isEmpty) { ... return; }

      final attributes = <String, dynamic>{};
      if (_selectedActionType == ActionType.navigate) {
        attributes['targetScreenId'] = _navigateTargetIdController.text.trim();
      } else if (_selectedActionType == ActionType.showAlert) {
        // Get values safely
        final title = _alertTitleController.text.trim();
        final message = _alertMessageController.text.trim();
        final buttonText = _alertButtonTextController.text.trim();

        attributes['message'] =
            message; // Message is required by form validation
        if (title.isNotEmpty) {
          attributes['title'] = title;
        }
        if (buttonText.isNotEmpty) {
          attributes['buttonText'] = buttonText;
        }
      }

      final resultData = {
        'id': actionId,
        'action': {
          'actionType': _getActionTypeString(_selectedActionType),
          'attributes': attributes,
        },
      };
      Navigator.of(context).pop(resultData); // Return the data
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Action' : 'Add New Action'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _actionIdController,
                decoration: const InputDecoration(labelText: 'Action ID'),
                // Disable editing ID if it already exists?
                readOnly: _isEditing,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an Action ID';
                  }
                  // TODO: Add validation for uniqueness if adding new?
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ActionType>(
                value: _selectedActionType,
                decoration: const InputDecoration(labelText: 'Action Type'),
                items: ActionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getActionTypeString(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedActionType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // Show fields based on selected type
              if (_selectedActionType == ActionType.navigate)
                _buildNavigateFields()
              else if (_selectedActionType == ActionType.showAlert)
                _buildShowAlertFields(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Close without saving
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveForm,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildNavigateFields() {
    return TextFormField(
      controller: _navigateTargetIdController,
      decoration: const InputDecoration(labelText: 'Target Screen ID'),
      validator: (value) {
        if (_selectedActionType == ActionType.navigate &&
            (value == null || value.trim().isEmpty)) {
          return 'Target Screen ID is required for Navigate';
        }
        return null;
      },
    );
  }

  Widget _buildShowAlertFields() {
    return Column(
      children: [
        TextFormField(
          controller: _alertTitleController,
          decoration: const InputDecoration(labelText: 'Title (Optional)'),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _alertMessageController,
          decoration: const InputDecoration(labelText: 'Message'),
          validator: (value) {
            if (_selectedActionType == ActionType.showAlert &&
                (value == null || value.trim().isEmpty)) {
              return 'Message is required for ShowAlert';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _alertButtonTextController,
          decoration: const InputDecoration(
            labelText: 'Button Text (Optional, default: OK)',
          ),
        ),
      ],
    );
  }
}
