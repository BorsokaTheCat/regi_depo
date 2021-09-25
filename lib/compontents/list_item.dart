import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem extends StatefulWidget {
  final String title;

  const ListItem({Key key, this.title, }) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return  Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0), //line and text
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0), // just text
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.red,
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
                      Text(widget.title, style: textTheme.subhead),
                    ],
                  ),
                ),

              ],
            ),
          ),
    );
  }
}
