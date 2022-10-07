import 'package:flutter/material.dart';
import 'package:nice_shot/presentation/widgets/primary_button_widget.dart';
import 'package:nice_shot/presentation/widgets/secondary_button_widget.dart';

class AlertDialogWidget extends StatelessWidget {
  final Function function;
  final String message;
  final String title;

  const AlertDialogWidget({
    Key? key,
    required this.message,
    required this.title,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(4.0),
      alignment: AlignmentDirectional.center,

      title: Center(
        child: Expanded(
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      // content: Text(
      //   message,
      //   style: Theme.of(context).textTheme.bodyText2,
      // ),
      actions: [
        Row(
          children: [
            Expanded(
                child: SecondaryButtonWidget(
              function: () => Navigator.pop(context),
              text: "CANCEL",
            )),
            const SizedBox(width: 5.0),
            Expanded(
                child: PrimaryButtonWidget(
              function: () => function(),
              text: "YES",
            )),
          ],
        ),
      ],
    );
  }
}
