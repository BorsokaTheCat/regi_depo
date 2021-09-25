import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final Color iconColor;
  final void Function() onPressed;
  final TextEditingController controller;

  const CustomTextField({
    Key key,
    this.iconColor = Colors.black,
    this.onPressed,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 15.0, vertical: 5.0), //line and text
        padding: const EdgeInsets.symmetric(
            horizontal: 10.0, vertical: 7.0), // just text
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Color(0xff595669),
                width: 2.0,
              ),
            )),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      cursorColor: Color(0xff3f1272),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: "másodpercek"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
