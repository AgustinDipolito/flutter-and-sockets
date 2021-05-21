import 'package:flutter/material.dart';

import 'package:nameband/models/band.dart';
import 'package:nameband/services/socket_services.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [];

  @override
  void initState() {
    //escuchar la lista de bandas
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.on("active bands", _handleActiveBands);

    super.initState();
  }

//manejo de bandas
  _handleActiveBands(dynamic payload) {
    this.bandas = (payload as List).map((band) => Band.fromMap(band)).toList();

    setState(() {});
  }

  @override
  void dispose() {
    //dejar de escuchar
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.off("active bands");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketServices>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bands and votes",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(
                    Icons.flash_on_outlined,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.wifi_off,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bandas.length,
              itemBuilder: (context, i) => bandTile(bandas[i]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addband,
      ),
    );
  }

  Widget bandTile(Band banda) {
    final socketService = Provider.of<SocketServices>(context);
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Remove band",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
      onDismissed: (_) => socketService.emit("deleteBand", {"id": banda.id}),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            banda.name.substring(0, 2),
          ),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.name),
        trailing: Text(
          "${banda.votes}",
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => socketService.emit("vote band", {"id": banda.id}),
      ),
    );
  }

  addband() {
    final textcontroller = new TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Add new band"),
          content: TextField(
            controller: textcontroller,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                "Add",
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                //añadir a la lista
                if (textcontroller.text.length > 1) {
                  final socketService =
                      Provider.of<SocketServices>(context, listen: false);
                  socketService.emit("addBand", {"name": textcontroller.text});
                }
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();

    bandas.forEach(
      (banda) {
        dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble());
      },
    );
    List<Color> colorList = [
      Colors.blue[100],
      Colors.blue[300],
      Colors.blue[500],
      Colors.blue[700],
      Colors.blue[900],
    ];

    return Container(
      height: 200,
      width: double.infinity,
      child: PieChart(
        dataMap: dataMap,
        colorList: colorList,
        chartValuesOptions: ChartValuesOptions(
          showChartValuesOutside: true,
        ),
      ),
    );
  }
}
