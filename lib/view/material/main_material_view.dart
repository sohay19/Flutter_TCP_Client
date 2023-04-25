
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../provider/main_provider.dart';


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
          child: ElevatedButton(
            child: Text('search'),
            onPressed: () {
              context.read<MainProvider>().searchServer();
            },
          )
        ),
      ),
    );
  }
}