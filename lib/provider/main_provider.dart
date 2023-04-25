
import 'package:flutter/widgets.dart';

import '../utils/enums.dart';
import '../view_model/main_view_model.dart';


class MainProvider with ChangeNotifier {
  late MainViewModel _mainViewmodel;

  String get message => _mainViewmodel.message;


  MainProvider() {
    _mainViewmodel = new MainViewModel();
    _mainViewmodel.notify = notifyListeners;
  }

  searchServer() {
    _mainViewmodel.searchServer();
  }

  sendServer(OperatorType type) {
    _mainViewmodel.sendServer(type);
  }

  closeSocket() {
    _mainViewmodel.closeSocket();
  }

  clearMessage() {
    _mainViewmodel.clearMsg();
  }
}