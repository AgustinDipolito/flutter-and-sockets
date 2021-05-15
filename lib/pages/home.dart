import 'package:flutter/material.dart';

import 'package:nameband/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bandas = [
    Band(id: "1", name: "duki", votes: 5),
    Band(id: "2", name: "khea", votes: 2),
    Band(id: "3", name: "jorge", votes: 3),
    Band(id: "4", name: "britney", votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bands and votes",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bandas.length,
        itemBuilder: (context, i) => bandTile(bandas[i]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addband,
      ),
    );
  }

  Widget bandTile(Band banda) {
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
            )),
        onDismissed: (direction) {},
        child: ListTile(
          leading: CircleAvatar(
            child: Text(banda.name.substring(0, 2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(banda.name),
          trailing: Text(
            "${banda.votes}",
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            print(banda.name);
          },
        ));
  }

  addband() {
    final textcontroller = new TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
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
                  this.bandas.add(new Band(
                      name: textcontroller.text,
                      id: DateTime.now().toString(),
                      votes: 0));
                }
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
