
import '../controller/socket_controller.dart';


class MainViewModel {
  late SocketController socketController;


  MainViewModel() {
    socketController = new SocketController();
    socketController.setNetworkInfo();
  }
}