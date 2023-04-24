
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';


class CupertinoMainPage extends StatefulWidget {
  final String title;

  CupertinoMainPage(this.title);


  @override
  State<CupertinoMainPage> createState() => _MaterialMainPageState();
}

class _MaterialMainPageState extends State<CupertinoMainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: SafeArea(
        child: Center(
          child: Text(''),
        ),
      ),
    );
  }
}