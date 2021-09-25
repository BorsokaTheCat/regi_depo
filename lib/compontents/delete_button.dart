import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Color iconColor;
  final void Function() onPressed;

  const DeleteButton({
    Key key,
    this.iconColor = Colors.black,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.all(0),
      minWidth: 30,
      child: FlatButton(
        onPressed: onPressed,
        child: Icon(
          Icons.delete,
          size: 30,
          color: iconColor,
        ),
      ),
    );
  }
}
