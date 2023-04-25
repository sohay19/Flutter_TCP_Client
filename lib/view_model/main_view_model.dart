
import '../controller/socket_controller.dart';


class MainViewModel {
  late SocketController _socketController;


  MainViewModel() {
    _socketController = new SocketController();
    _socketController.setNetworkInfo();
  }

  searchServer() {
    _socketController.setNetworkInfo();
  }
}