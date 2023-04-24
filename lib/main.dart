import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/main_provider.dart';
import 'view/cupertino/main_cupertino_view.dart';
import 'view/material/main_material_view.dart';


void main() {
  runApp( ChangeNotifierProvider(
    create: (_) => MainProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final String title = 'TCP Client';

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoPage(title);
    } else {
      return MaterialPage(title);
    }
  }
}

class MaterialPage extends StatelessWidget {
  final String title;

  MaterialPage(this.title);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MaterialMainPage(title),
    );
  }
}


class CupertinoPage extends StatelessWidget {
  final String title;

  CupertinoPage(this.title);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: CupertinoMainPage(title),
    );
  }
}