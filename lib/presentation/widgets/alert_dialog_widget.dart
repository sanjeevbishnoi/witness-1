import 'package:flutter/material.dart';
import 'package:nice_shot/core/themes/app_theme.dart';

class AlertDialogWidget extends StatelessWidget {
  final Function function;
  final TextEditingController controller;

  const AlertDialogWidget({
    Key? key,
    required this.function,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20.0),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              cursorColor: MyColors.primaryColor,
              decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  labelText: 'Edit name',
                  hintText: 'eg. Nice shot',
                  labelStyle: TextStyle(color: MyColors.primaryColor)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'SAVE',
            style: TextStyle(color: MyColors.primaryColor),
          ),
          onPressed: () => function(),
        ),
      ],
    );
  }
}
