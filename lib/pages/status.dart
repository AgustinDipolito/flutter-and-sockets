import 'package:flutter/material.dart';
import 'package:nameband/services/socket_services.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketServices>(context);
    return Scaffold(
      body: Center(
        child: Text("Estado: ${socketService.serverStatus}"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          socketService.emit("mensajeDesdeApp", "Holaaa");
        },
      ),
    );
  }
}
