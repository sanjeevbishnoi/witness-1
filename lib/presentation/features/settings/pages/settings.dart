import 'package:flutter/material.dart';
import 'package:nice_shot/core/util/global_variables.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/data/network/local/cache_helper.dart';
import 'package:nice_shot/presentation/features/profile/widgets/action_item_widget.dart';
import 'package:nice_shot/presentation/widgets/alert_dialog_widget.dart';

import '../../../../core/functions/functions.dart';
import '../../../../core/routes/routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.widgetSideSpace),
      child: Column(
        children: [
          ActionItemWidget(
            icon: Icons.lock_clock_rounded,
            function: () => Navigator.pushNamed(
              context,
              Routes.resetPassword,
            ),
            text: "Reset Password",
          ),
          const SizedBox(height: MySizes.verticalSpace),
          ActionItemWidget(
            icon: Icons.delete_forever_rounded,
            function: () {},
            text: "Delete Account",
          ),
          const SizedBox(height: MySizes.verticalSpace),
          ActionItemWidget(
            icon: Icons.exit_to_app,
            function: () =>logOut(context: context),
            text: "Logout",
          ),
        ],
      ),
    );
  }
}
