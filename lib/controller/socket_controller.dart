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
          print('========= Broadcast =========');
          String receiveData = String.fromCharCodes(datagram.data);
          print("${receiveData}");
        }
      });
      final String sendMsg = 'search ${_myInfo.ip} ${Static.MY_PORT}';
      final sendData = utf8.encode(sendMsg);
      socket.send(sendData, InternetAddress('255.255.255.255'), Static.UDP_PORT);
      await Future.delayed(Duration(milliseconds: 1000));
      socket.close();
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
      final receiveMsg = String.fromCharCodes(data);
      print('===== receiveData =====');
      print(receiveMsg);
    } catch (e) {
      throw ErrorType.SEND;
    }
  }
}