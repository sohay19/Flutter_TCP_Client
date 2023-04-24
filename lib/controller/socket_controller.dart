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

  late Socket _socket;
  late AddressInfo _myInfo;


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
  }

  _searchServer() async {
    try {
      RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, Static.UDP_PORT);
      socket.broadcastEnabled = true;
      final String sendMsg = 'search ${_myInfo.ip}';
      final sendData = utf8.encode(sendMsg);
      _socket.add(sendData);
      await Future.delayed(Duration(milliseconds: 500));
      _socket.close();
    } catch (e) {
      throw ErrorType.BIND;
    }
  }

  _connectServer() async {
    try {
      _socket = await Socket.connect('', Static.TCP_PORT);
      _socket.listen(_listenProcess);
    } catch (e) {
      throw ErrorType.BIND;
    }
  }

  _listenProcess(Uint8List data) {
    try {

    } catch (e) {
      throw ErrorType.SEND;
    }
  }
}