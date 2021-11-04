//
//  EnhanceExpandListViewDemo.dart
//  enhance_expansion_panel
//
//  Created by shang on 11/4/21 11:11 AM.
//  Copyright © 11/4/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:enhance_expansion_panel/enhance_expansion_panel.dart';

class EnhanceExpandListViewDemo extends StatefulWidget {

  final String? title;

  EnhanceExpandListViewDemo({ Key? key, this.title}) : super(key: key);


  @override
  _EnhanceExpandListViewDemoState createState() => _EnhanceExpandListViewDemoState();
}

class _EnhanceExpandListViewDemoState extends State<EnhanceExpandListViewDemo> {

  final _tuples = [
    Tuple2("section0", List.generate(0, (index) => Tuple2("0", "$index"))),
    Tuple2("section1", List.generate(1, (index) => Tuple2("1", "$index"))),
    Tuple2("section2", List.generate(2, (index) => Tuple2("2", "$index"))),
    Tuple2("section3", List.generate(3, (index) => Tuple2("3", "$index"))),

  ];

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
      ),
      body: EnhanceExpandListView(
        children: _tuples.map<ExpandPanelModel<Tuple2<String, String>>>((e) => ExpandPanelModel(
          canTapOnHeader: true,
          isExpanded: false,
          arrowPosition: EnhanceExpansionPanelArrowPosition.none,
          // backgroundColor: Color(0xFFDDDDDD),
          headerBuilder: (contenx, isExpand) {
            return Container(
              // color: Colors.green,
              color: isExpand ? Colors.black12 : null,
              child: ListTile(
                title: Text("${e.item1}", style: TextStyle(fontWeight: FontWeight.bold),),
                trailing: Text("${e.item2.length}"),
              ),
            );
          },
          bodyChildren: e.item2,
          bodyItemBuilder: (context, e) {
            return ListTile(
                title: Text(e.item2, style: TextStyle(fontSize: 14),),
                // subtitle: Text(e.item2, style: TextStyle(fontSize: 12),),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  print([DateTime.now(), e.item1, e.item2].toString());
                });
          },
        )).toList(),)
    );
  }

}


