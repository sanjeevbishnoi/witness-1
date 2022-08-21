import 'package:flutter/material.dart';
import 'package:nice_shot/core/themes/app_theme.dart';

class WrapperWidget extends StatelessWidget {
  final String title;
  final Widget body;

  const WrapperWidget({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title.toUpperCase()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(MySizes.widgetSidePadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   const SizedBox(height: MySizes.verticalPadding * 2),
                body,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
