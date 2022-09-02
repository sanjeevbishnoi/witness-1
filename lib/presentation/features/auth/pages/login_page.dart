import 'package:flutter/material.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/auth/widgets/wrapper.dart';
import 'package:nice_shot/presentation/widgets/form_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WrapperWidget(
      title: "Login",
      body: Column(
        children: [
          FormWidget(
            route: Routes.loginPage,
            emailController: emailController,
            passwordController: passwordController,
            context: context,
          ),
          const SizedBox(height: MySizes.verticalPadding),
          PrimaryButtonWidget(
            function: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homePage,
              (route) => false,
            ),
            text: "login",
          ),
          const SizedBox(height: MySizes.verticalPadding),
          SecondaryButtonWidget(
            function: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.registerPage,
              (route) => false,
            ),
            text: "register",
          ),
        ],
      ),
    );
  }
}
