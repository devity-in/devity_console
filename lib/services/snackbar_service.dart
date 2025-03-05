import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:devity_console/config/custom_key.dart';
import 'package:flutter/material.dart';

/// Snackbar service to show snackbar messages
class SnackbarService {
  /// Show negative snackbar
  void showNegativeSnackbar(String errorMessage) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of
      ///  awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: errorMessage,

        /// change contentType to ContentType.success, ContentType.warning or
        ///  ContentType.help for variants
        contentType: ContentType.failure,
      ),
    );
    final scaffoldMessenger = CustomKey.scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null || scaffoldMessenger.mounted == false) {
      debugPrint('ScaffoldMessenger not available');
      return;
    }
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show positive snackbar
  void showPositiveSnackbar(String successMessage) {
    final snackBar = SnackBar(
      /// need to set following properties for best effect of
      ///  awesome_snackbar_content
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Awesome!',
        message: successMessage,

        /// change contentType to ContentType.success, ContentType.warning or
        ///  ContentType.help for variants
        contentType: ContentType.success,
      ),
    );
    final scaffoldMessenger = CustomKey.scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null || scaffoldMessenger.mounted == false) {
      debugPrint('ScaffoldMessenger not available');
      return;
    }
    scaffoldMessenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

/// Singleton instance of [SnackbarService]
final SnackbarService snackbarService = SnackbarService();
