
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MaterialMainPage extends StatefulWidget {
  final String title;

  MaterialMainPage(this.title);


  @override
  State<MaterialMainPage> createState() => _MaterialMainPageState();
}

class _MaterialMainPageState extends State<MaterialMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Text(''),
        ),
      ),
    );
  }
}