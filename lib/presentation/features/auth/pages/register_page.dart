import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/model/api/User_model.dart';
import 'package:nice_shot/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:nice_shot/presentation/features/auth/widgets/wrapper.dart';
import 'package:nice_shot/presentation/widgets/error_widget.dart';
import 'package:nice_shot/presentation/widgets/form_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

import '../../../widgets/snack_bar_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
            emailController: emailController,
            dobController: dobController,
            confirmPasswordController: confirmPwdController,
            context: context,
          ),
          const SizedBox(height: MySizes.verticalPadding),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.requestState == RequestState.loading) {
                return const LoadingWidget();
              } else if (state.requestState == RequestState.loaded) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBarWidget(
                    message: state.message!,
                  ));
                  Navigator.pushNamed(context, Routes.verifyCodePage);
                });
              } else if (state.message != null) {
                return ErrorMessageWidget(error: state.message!);
              }
              return PrimaryButtonWidget(
                function: () {
                  UserModel user = UserModel(
                    name: usernameController.text,
                    email: emailController.text,
                    birthDate: dobController.text,
                    mobile: "398573489",
                    nationality: "Egypt",
                    password: passwordController.text,
                    logo: state.file!,
                    userName: usernameController.text
                        .toLowerCase()
                        .replaceAll(" ", "_"),
                  );
                  context.read<AuthBloc>().add(CreateAccountEvent(user: user));
                },
                text: "register",
              );
            },
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
