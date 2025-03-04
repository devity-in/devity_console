import 'package:devity_console/modules/auth/view/login.dart';
import 'package:devity_console/services/snackbar_service.dart';
import 'package:devity_console/widgets/mobile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Signup page
class MobileSignup extends StatefulWidget {
  /// Signup page cons
  const MobileSignup({super.key});

  @override
  State<MobileSignup> createState() => _MobileSignupState();
}

class _MobileSignupState extends State<MobileSignup> {
  final TextEditingController userNameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController conformPasswordTextController =
      TextEditingController();

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
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MobileTextEditor(
              title: 'User Name',
              textEditingController: userNameTextController,
              keyboardType: TextInputType.text,
            ),
            MobileTextEditor(
              title: 'Email',
              textEditingController: emailTextController,
              keyboardType: TextInputType.text,
            ),
            MobileTextEditor(
              title: 'Password',
              textEditingController: passwordTextController,
              keyboardType: TextInputType.text,
            ),
            MobileTextEditor(
              title: 'Conform Password',
              textEditingController: conformPasswordTextController,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(
              height: 150,
            ),
            ElevatedButton(
              onPressed: () {
                final userName = userNameTextController.text;
                final email = emailTextController.text;
                final password = passwordTextController.text;
                if (password != conformPasswordTextController.text) {
                  snackbarService.showNegativeSnackbar('Password not match');
                  return;
                } else if (email.isEmpty ||
                    password.isEmpty ||
                    userName.isEmpty) {
                  snackbarService
                      .showNegativeSnackbar('Please fill all fields');
                } else if (email.isNotEmpty ||
                    password.isNotEmpty ||
                    userName.isNotEmpty) {
                  // authenticationBloc
                  //     .signUp(email, password, userName)
                  //     .then((user) => {
                  //           if (user != null)
                  //             {
                  //               snackbarService.showPositiveSnackbar(
                  //                   "Signed up successfully"),
                  //             }
                  //         });
                }
              },
              style: ButtonStyle(
                side: const WidgetStatePropertyAll(
                  BorderSide(
                    color: Colors.white,
                  ),
                ),
                minimumSize: const WidgetStatePropertyAll(
                  Size.fromHeight(
                    40,
                  ),
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).primaryColor,
                ),
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: Text(
                'Signup'.toUpperCase(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have account,',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileLogin(),
                      ),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
