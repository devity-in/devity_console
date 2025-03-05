import 'package:devity_console/services/snackbar_service.dart';
import 'package:devity_console/widgets/desktop_basic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Forgot password screen
class ForgotPassword extends StatefulWidget {
  /// Forgot password screen constructor
  const ForgotPassword({
    required this.email,
    super.key,
  });
  /// Requires email to be passed
  final String email;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late final TextEditingController emailController;
  
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          children: [
            DesktopTextEditor(
              title: 'Email',
              textEditingController: emailController,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isEmpty) {
                  snackbarService
                      .showNegativeSnackbar('Please enter registered email');
                }
                // authenticationBloc
                //     .resetPassword(emailController.text)
                //     .then((saved) {
                //   snackbarService.showPositiveSnackbar(
                //       "Email is sent to your email address");
                //   Navigator.pop(context);
                // });
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
