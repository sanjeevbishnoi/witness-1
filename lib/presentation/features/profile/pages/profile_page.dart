import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/data/model/api/User_model.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/widgets/error_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PROFILE"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.requestState == RequestState.loading) {
            return const LoadingWidget();
          } else if (state.requestState == RequestState.loaded) {
            UserModel user = state.user!.data!;
            return Padding(
              padding: const EdgeInsets.all(MySizes.widgetSidePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MySizes.imageHeight,
                        width: MySizes.imageWidth,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(MySizes.imageRadius),
                          image: user.logoUrl != null
                              ? DecorationImage(
                                  image: AssetImage(user.logoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/defaultImage.jpg"),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(width: MySizes.horizontalPadding),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${user.name}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primaryColor,
                                ),
                          ),
                          const SizedBox(height: MySizes.verticalPadding),
                          Text(
                            "${user.mobile}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: MySizes.verticalPadding * 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: PrimaryButtonWidget(
                          function: () {},
                          text: "edit profile",
                        ),
                      ),
                      const SizedBox(width: MySizes.horizontalPadding),
                      Expanded(
                        child: SecondaryButtonWidget(
                          function: () {},
                          text: "settings",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state.requestState == RequestState.error) {
            return ErrorMessageWidget(error: state.message ?? "Unknown Error");
          }
          return const LoadingWidget();

        },
      ),
    );
  }
}
