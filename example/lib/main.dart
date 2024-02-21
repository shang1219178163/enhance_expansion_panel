import 'package:flutter/material.dart';

import 'enhance_expand_list_view_demo.dart';
import 'enhance_expansion_panel_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //
      //   primarySwatch: Colors.blue,
      // ),
      // // theme: ThemeData.light(),
      //  theme: ThemeData.dark().copyWith(
      //    // cardColor: Colors.red,
      //    iconTheme: const IconThemeData(color: Colors.red),
      //  ),
      home: MyHomePage(title: 'Home Page'),
        // home: EnhanceExpansionPanelDemo(title: 'EnhanceExpansionPanelDemo'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => EnhanceExpandListViewDemo()),
            );
          }, child: const Text("fold list", style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: const EnhanceExpansionPanelDemo(title: 'EnhanceExpansionPanelDemo', appBarHide: true,),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
