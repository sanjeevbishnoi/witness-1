import 'package:flutter/material.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/auth/widgets/wrapper.dart';
import 'package:nice_shot/presentation/widgets/form_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return WrapperWidget(
      title: "Login",
      body: Column(
        children: [
          FormWidget(
            route: Routes.loginPage,
            phoneController: phoneController,
            passwordController: passwordController,
            context: context,
          ),
          const SizedBox(height: MySizes.verticalPadding),
          PrimaryButtonWidget(
            function: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.cameraPage,
                  (route) => false,
            ),            text: "login",
          ),
          const SizedBox(height: MySizes.verticalPadding),
          SecondaryButtonWidget(
            function: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.registerPage,
                  (route) => false,
            ),            text: "register",
          ),
        ],
      ),
    );
  }
}
