import 'package:devity_console/l10n/l10n.dart';
import 'package:devity_console/modules/auth/cubit/cubit.dart';
import 'package:devity_console/modules/auth/view/forgot_password.dart';
import 'package:devity_console/modules/auth/view/signup.dart';
import 'package:devity_console/widgets/mobile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mobile Login page
class MobileLogin extends StatefulWidget {
  /// Constructor
  const MobileLogin({super.key});

  @override
  State<MobileLogin> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
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
              title: 'Email',
              textEditingController: emailTextController,
              keyboardType: TextInputType.emailAddress,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: MobileTextEditor(
                title: 'Password',
                textEditingController: passwordTextController,
                keyboardType: TextInputType.text,
                obscureText: true,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (context) => ForgotPassword(
                        email: emailTextController.text,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                final emailAddress = emailTextController.text.trim();
                final password = passwordTextController.text.trim();
                context.read<AuthCubit>().logIn(
                      emailAddress,
                      password,
                    );
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
                'Login'.toUpperCase(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                // authenticationBloc.signInWithGoogle().then((user) {
                //   if (user != null) {
                //     snackbarService.showPositiveSnackbar(
                //       "Login Successful",
                //     );
                //   }
                // });
              },
              style: ButtonStyle(
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                backgroundColor: const WidgetStatePropertyAll(
                  Colors.white,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google_logo.png',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'LOGIN / SIGN UP WITH GOOGLE',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account,",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (context) => const MobileSignup(),
                      ),
                    );
                  },
                  child: Text(
                    'Signup',
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
