import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/enums.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';
import 'package:nice_shot/data/model/api/User_model.dart';
import 'package:nice_shot/presentation/features/edited_videos/pages/uploaded_edited_videos_page.dart';
import 'package:nice_shot/presentation/features/profile/bloc/user_bloc.dart';
import 'package:nice_shot/presentation/features/profile/widgets/user_info_widget.dart';
import 'package:nice_shot/presentation/widgets/error_widget.dart';
import 'package:nice_shot/presentation/widgets/loading_widget.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

import '../../../../core/routes/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.requestState == RequestState.loading) {
          return const LoadingWidget();
        } else if (state.requestState == RequestState.loaded) {
          UserModel? user = state.user!.data;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(MySizes.widgetSideSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        user?.logoUrl != null
                            ? CircleAvatar(
                                radius: 50.0,
                                backgroundImage: NetworkImage(
                                  "${user!.logoUrl}",
                                ),
                              )
                            : const CircleAvatar(
                                radius: 50.0,
                                backgroundImage: AssetImage(
                                  "assets/images/defaultImage.jpg",
                                ),
                              ),
                        const SizedBox(height: MySizes.verticalSpace),
                        Text(
                          "${user?.name}",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: MySizes.verticalSpace / 2),
                        Text(
                          "${user?.userName}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: MySizes.verticalSpace * 3),
                  Row(
                    children: [
                      UserInfoWidget(text: "Mobile", info: user?.mobile),
                      const SizedBox(width: MySizes.horizontalSpace),
                      UserInfoWidget(text: "Email", info: user?.email),
                    ],
                  ),
                  const SizedBox(height: MySizes.verticalSpace),
                  Row(
                    children: [
                      UserInfoWidget(text: "Birth Date", info: user?.birthDate),
                      const SizedBox(width: MySizes.horizontalSpace),
                      UserInfoWidget(
                          text: "Nationality", info: user?.nationality),
                    ],
                  ),
                  const SizedBox(height: MySizes.verticalSpace * 3),
                  SecondaryButtonWidget(
                    function: () =>
                        Navigator.pushNamed(context, Routes.editProfilePage),
                    text: "edit profile",
                  )
                ],
              ),
            ),
          );
        } else if (state.requestState == RequestState.error) {
          return ErrorMessageWidget(message: state.message ?? "Unknown Error");
        }
        return const LoadingWidget();
      },
    );
  }
}
