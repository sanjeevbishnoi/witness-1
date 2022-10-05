import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/network/local/cache_helper.dart';
import 'package:nice_shot/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:nice_shot/presentation/features/auth/widgets/wrapper.dart';
import 'package:nice_shot/presentation/widgets/error_widget.dart';
import 'package:nice_shot/presentation/widgets/form_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/snack_bar_widget.dart';

import '../../../../core/global_variables.dart';
import '../../../../data/model/api/login_model.dart';

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
          const SizedBox(height: MySizes.verticalSpace),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state.loginState == RequestState.loaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  snackBarWidget(message: state.message!),
                );
              }
              if (state.loginState == RequestState.loaded &&
                  state.login != null) {
                await CacheHelper.saveData(
                  key: "user",
                  value: json.encode(state.login!),
                ).then((value) {
                  final user = CacheHelper.getData(key: "user");
                  currentUserData = LoginModel.fromJson(json.decode(user));
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.homePage,
                    (route) => false,
                  );
                });
              }
            },
            builder: (context, state) {
              switch (state.loginState) {
                case RequestState.loading:
                  return const LoadingWidget();
                case RequestState.loaded:
                  break;
                case RequestState.error:
                  SchedulerBinding.instance.addPostFrameCallback((_) async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      snackBarWidget(message: state.message!),
                    );
                  });
                  break;
                default:
              }
              return Column(
                children: [
                  PrimaryButtonWidget(
                    function: () {
                      context.read<AuthBloc>().add(LoginEvent(
                            email: emailController.text,
                            password: passwordController.text,
                          ));
                    },
                    text: "login",
                  ),
                  const SizedBox(height: MySizes.verticalSpace),
                  SecondaryButtonWidget(
                    function: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.registerPage,
                      (route) => false,
                    ),
                    text: "register",
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
