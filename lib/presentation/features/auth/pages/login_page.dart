import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/global_variables.dart';
import 'package:nice_shot/core/routes/routes.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/repositories/user_repository.dart';
import 'package:nice_shot/presentation/features/auth/bloc/auth_bloc.dart';
import 'package:nice_shot/presentation/features/auth/widgets/wrapper.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/widgets/error_widget.dart';
import 'package:nice_shot/presentation/widgets/form_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/snack_bar_widget.dart';

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
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.requestState == RequestState.loading) {
                return const LoadingWidget();
              } else if (state.requestState == RequestState.loaded) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  currentUserData = state.login!;
                  myToken = state.login!.token!;
                  context.read<UserBloc>().add(
                        GetUserDataEvent(id: "${currentUserData!.user!.id}"),
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBarWidget(message: state.message!),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.homePage,
                    (route) => false,
                  );
                });
              } else if (state.message != null) {
                return ErrorMessageWidget(error: state.message!);
              }
              return PrimaryButtonWidget(
                function: () {
                  context.read<AuthBloc>().add(LoginEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ));
                },
                text: "login",
              );
            },
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
