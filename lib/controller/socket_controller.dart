import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../model/address_info.dart';
import '../utils/enums.dart';
import '../utils/statc_value.dart';


class SocketController {
  final Connectivity _connectivify = Connectivity();
  late AddressInfo _myInfo;

  Socket? _socket;
  AddressInfo? _serverInfo;
  String showMsg = '';
  Function? sendShowMessage;


  SocketController() {
    _myInfo = new AddressInfo();
  }

  setNetworkInfo() async {
    try {
      ConnectivityResult connectivityResult = await _connectivify.checkConnectivity();
      //
      if (Platform.isIOS || Platform.isAndroid) {
        if (connectivityResult == ConnectivityResult.wifi) {
          await _getWifiInfo();
        } else {
          throw ErrorType.NO_NETWORK;
        }
      } else if (Platform.isWindows || Platform.isMacOS) {
        if (connectivityResult == ConnectivityResult.ethernet) {
          await _getEthernetInfo();
        } else if (connectivityResult == ConnectivityResult.wifi) {
          await _getWifiInfo();
        } else {
          throw ErrorType.NO_NETWORK;
        }
      }
    } catch(e) {
      throw ErrorType.NO_SUPPORT_PLATFORM;
    }
  }

  _getWifiInfo() async {
    String ip = '';

    final info = NetworkInfo();
    ip = await info.getWifiIP() ?? "";

    _myInfo.ip = ip;
    _myInfo.port = Static.UDP_PORT;
    _searchServer();
  }

  _getEthernetInfo() async {
    String ip = '';

    for(var interface in await NetworkInterface.list()) {
      for(var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          ip = addr.address;
        }
      }
    }
    _myInfo.ip = ip;
    _myInfo.port = Static.UDP_PORT;
    _searchServer();
  }

  _searchServer() async {
    try {
      RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, Static.MY_PORT);
      socket.broadcastEnabled = true;
      socket.listen((event) {
        Datagram? datagram = socket.receive();
        if (datagram != null) {
          String receiveMsg = String.fromCharCodes(datagram.data);
          showMsg += '>> Receive\n';
          showMsg += '${receiveMsg}\n';
          final list = receiveMsg.split(' ');
          _serverInfo = new AddressInfo();
          _serverInfo?.ip = list.first;
          _serverInfo?.port = int.parse(list.last);
          _endProcess();
        }
      });
      final String sendMsg = 'search ${_myInfo.ip} ${Static.MY_PORT}';
      showMsg += 'Search Server\n\n';
      showMsg += '>> Send\n';
      showMsg += '${sendMsg}\n';
      _endProcess();
      final sendData = utf8.encode(sendMsg);
      socket.send(sendData, InternetAddress('255.255.255.255'), Static.UDP_PORT);
      await Future.delayed(Duration(milliseconds: Static.UDP_TIME_OUT));
      socket.close();
      if (_serverInfo != null) {
        _connectServer();
      }
    } catch (e) {
      throw ErrorType.BIND;
    }
  }

  _connectServer() async {
    try {
      if (_serverInfo != null) {
        final AddressInfo server = _serverInfo!;
        showMsg += '>> Connect\n';
        showMsg += 'Connecting...\n';
        _endProcess();

        _socket = await Socket.connect(InternetAddress(server.ip), server.port);
        _socket?.listen(_listenProcess);
      }
    } catch (e) {
      throw ErrorType.CONNECT;
    }
  }

  _listenProcess(Uint8List data) {
    try {
      String result = '';
      final receiveMsg = String.fromCharCodes(data);
      final list = receiveMsg.split(' ');
      if (list.length > 1) {
        final type = OperatorType.values.firstWhere((element) => element.msg == list.first);
        switch (type) {
          case OperatorType.GETINT:
            result = 'INT = ' + list.last;
            break;
          case OperatorType.GETSTRING:
            result = 'STRING = ' + list.last;
            break;
          default:
            break;
        }
      } else {
        result = receiveMsg;
      }
      showMsg += '>> Receive\n';
      showMsg += '${result}\n';
      _endProcess();
    } catch (e) {
      throw ErrorType.RECEIVE;
    }
  }

  sendMessage(OperatorType type) {
    try {
      final sendMsg = type.msg;
      showMsg += '>> Send\n';
      showMsg += '${sendMsg}\n\n';
      _socket?.add(utf8.encode(sendMsg));
    } catch (e) {
      throw ErrorType.SEND;
    }
  }

  _endProcess() {
    sendShowMessage?.call(showMsg);
    showMsg = '';
  }

  closeSocket() {
    _socket?.close();
    _serverInfo = null;
    showMsg += 'Close\n';
    _endProcess();
  }
}