import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketServices with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket _socket;
  IO.Socket get socket => this._socket;

  Function get emit => this._socket.emit;

  SocketServices() {
    this._initConfig();
  }

  void _initConfig() {
//192.168.0.168
    this._socket = IO.io(
      'http://192.168.0.168:3005',
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .enableAutoConnect()
          .setExtraHeaders({"foo": "bar"})
          .build(),
    );
    this._socket.connect();

    this._socket.onConnect(
      (_) {
        this._serverStatus = ServerStatus.Online;
        print("$_serverStatus");
        notifyListeners();
      },
    );

    this._socket.onDisconnect(
      (_) {
        this._serverStatus = ServerStatus.Offline;
        print("$_serverStatus");
        notifyListeners();
      },
    );

    this._socket.on("nuevo-msj", (payload) => {print(payload)});
  }
}
