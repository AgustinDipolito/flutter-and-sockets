import 'package:flutter/material.dart';

import 'package:nameband/pages/home.dart';
import 'package:nameband/pages/status.dart';
import 'package:nameband/services/socket_services.dart';
import 'package:provider/provider.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketServices(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Vote now!",
        initialRoute: "home",
        routes: {
          "home": (_) => HomePage(),
          "status": (_) => StatusPage(),
        },
      ),
    );
  }
}
