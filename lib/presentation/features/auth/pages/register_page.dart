import 'package:flutter/material.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/features/auth/widgets/wrapper.dart';
import 'package:nice_shot/presentation/widgets/form_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WrapperWidget(
      title: "Register",
      body: Column(
        children: [
          FormWidget(
            route: Routes.registerPage,
            passwordController: passwordController,
            phoneController: phoneController,
            usernameController: usernameController,
            dobController: dobController,
            confirmPasswordController: confirmPwdController,
            context: context,
          ),
          const SizedBox(height: MySizes.verticalPadding),
          PrimaryButtonWidget(
            function: () => Navigator.pushNamed(context, Routes.verifyCodePage),
            text: "register",
          ),
          const SizedBox(height: MySizes.verticalPadding),
          SecondaryButtonWidget(
            function: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginPage,
              (route) => false,
            ),
            text: "login",
          ),
        ],
      ),
    );
  }
}
