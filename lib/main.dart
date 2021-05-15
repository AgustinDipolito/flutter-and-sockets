import 'package:flutter/material.dart';

import 'package:nameband/pages/home.dart';

void main() => runApp(Myapp());

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MAterial app",
      initialRoute: "home",
      routes: {
        "home": (_) => HomePage(),
      },
    );
  }
}
