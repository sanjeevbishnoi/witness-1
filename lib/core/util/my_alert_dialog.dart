import 'package:flutter/material.dart';
import 'package:nice_shot/presentation/widgets/alert_dialog_widget.dart';

myAlertDialog({
  required BuildContext context,
  required Function function,
  required TextEditingController controller,
}) async {
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialogWidget(function: function, controller: controller);
    },
  );
}
