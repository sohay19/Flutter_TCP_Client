
import 'package:flutter/widgets.dart';

import '../view_model/main_view_model.dart';


class MainProvider with ChangeNotifier {
  late MainViewModel _mainViewmodel;


  MainProvider() {
    _mainViewmodel = new MainViewModel();
  }

  searchServer() {
    _mainViewmodel.searchServer();
  }
}