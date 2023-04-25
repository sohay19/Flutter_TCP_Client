
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../provider/main_provider.dart';
import '../../utils/enums.dart';


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
        minimum: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
              child: _ButtonMenu(),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: _MessageView(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.black,
                  )
                ),
                onPressed: () {
                  context.read<MainProvider>().clearMessage();
                },
                child: Text(
                    'Clear',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ButtonMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white60,
                  )
              ),
              child: Text(
                  'Search',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                context.read<MainProvider>().searchServer();
              },
            ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.white60,
                )
            ),
            child: Text(
                'Get Int',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              context.read<MainProvider>().sendServer(OperatorType.GETINT);
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.white60,
                )
            ),
            child: Text(
                'Get String',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              context.read<MainProvider>().sendServer(OperatorType.GETSTRING);
            },
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.white60,
                )
            ),
            child: Text(
              'Close',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              context.read<MainProvider>().closeSocket();
            },
          ),
        ),
      ],
    );
  }
}

class _MessageView extends StatelessWidget {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final message = context.select<MainProvider, String>((provider) => provider.message);
    _scrolling();

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black,
          width: 0.5,
        )
      ),
      child: SingleChildScrollView(
        child: Text(message),
      ),
    );
  }

  _scrolling() {
    if(controller.positions.isNotEmpty) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}