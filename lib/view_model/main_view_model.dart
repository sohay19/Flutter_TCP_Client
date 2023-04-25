
import '../controller/socket_controller.dart';
import '../utils/enums.dart';


class MainViewModel {
  late SocketController _socketController;

  String message = '';
  Function? notify;


  MainViewModel() {
    _socketController = new SocketController();
    _socketController.sendShowMessage = _getMessage;
  }

  _getMessage(String msg) {
    message += '${msg}\n';
    notify?.call();
  }

  searchServer() {
    _socketController.setNetworkInfo();
  }

  sendServer(OperatorType type) {
    _socketController.sendMessage(type);
  }

  closeSocket() {
    _socketController.closeSocket();
  }

  clearMsg() {
    message = '';
    notify?.call();
  }
}