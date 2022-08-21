import 'package:flutter/material.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile".toUpperCase()),
      ),
      body: Padding(
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
                    borderRadius: BorderRadius.circular(MySizes.imageRadius),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/defaultImage.jpg"),
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
                      "Mohammed T. Elessi",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: MyColors.primaryColor,
                          ),
                    ),
                    const SizedBox(height: MySizes.verticalPadding),
                     Text("+972 59 2879633",style: Theme.of(context).textTheme.bodySmall,),
                  ],
                )
              ],
            ),
            const SizedBox(height: MySizes.verticalPadding*2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: PrimaryButtonWidget(function: () {}, text: "edit profile")),
                const SizedBox(width: MySizes.horizontalPadding),
                Expanded(child: SecondaryButtonWidget(function: () {}, text: "settings")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
