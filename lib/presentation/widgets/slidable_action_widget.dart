import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nice_shot/core/themes/app_theme.dart';
import 'package:nice_shot/core/util/my_box_decoration.dart';

class SlidableActionWidget extends StatelessWidget {
  final BuildContext context;
  final Color color;
  final IconData icon;
  final Function function;

  const SlidableActionWidget({
    Key? key,
    required this.context,
    required this.color,
    required this.icon,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => function(),
      child: Container(
        margin: const EdgeInsets.all(5.0),
        height: 50.0,
        width: 50.0,
        decoration: myBoxDecoration.copyWith(color: color),
        child: Icon(icon, size: 28.0, color: Colors.white),
      ),
    );
  }
}
