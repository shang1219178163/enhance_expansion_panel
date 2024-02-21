//
//  ExpandSectionListView.dart
//  fluttertemplet
//
//  Created by shang on 11/3/21 3:01 PM.
//  Copyright © 11/3/21 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'enhance_expansion_panel.dart';

// ignore: must_be_immutable
/// custom: Expand List view
class EnhanceExpandListView<E> extends StatefulWidget {

  const EnhanceExpandListView({
    Key? key,
    required this.children,
    this.controller,
  }) : super(key: key);

  final ScrollController? controller;
  final List<ExpandPanelModel<E>> children;

  @override
  _EnhanceExpandListViewState<E> createState() => _EnhanceExpandListViewState<E>();
}

class _EnhanceExpandListViewState<E> extends State<EnhanceExpandListView<E>> {

  late final _scrollController = widget.controller ?? ScrollController();


  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: EnhanceExpansionPanelList(
          // dividerColor: Colors.red,
          // elevation: 4,
          materialGapSize: 0,
          expandedHeaderPadding: const EdgeInsets.only(top: 0, bottom: 0),
          expansionCallback: (int index, bool isExpanded) {
            widget.children[index].isExpanded = !isExpanded;
            setState(() {});
          },
          children: widget.children.map((e) {
            return EnhanceExpansionPanel(
              isExpanded: e.isExpanded,
              canTapOnHeader: true,
              backgroundColor: e.backgroundColor,
              arrowColor: e.arrowColor,
              arrowPadding: e.arrowPadding,
              arrowPosition: e.arrowPosition,
              arrowExpanded: e.arrowExpanded,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return e.headerBuilder(context, isExpanded);
              },
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: e.bodyChildren.map((item) => Column(
                  children: [
                    // if (e.bodyChildren.first == item) Divider(),
                    e.bodyItemBuilder(context, item),
                    if (e.bodyChildren.last != item) const Divider(height: 1,),
                  ],
                )).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}


class ExpandPanelModel<E> extends EnhanceExpansionPanel {
  ExpandPanelModel({
    required this.bodyChildren,
    required this.bodyItemBuilder,
    headerBuilder,
    isExpanded = false,
    canTapOnHeader = true,
    backgroundColor,
    arrowColor = Colors.black54,
    arrowPadding,
    arrowPosition = EnhanceExpansionPanelArrowPosition.tailing,
    arrowExpanded,
    arrow,
  }) : super(headerBuilder: headerBuilder,
      body: Container(),
      isExpanded: isExpanded,
      canTapOnHeader: canTapOnHeader,
      backgroundColor: backgroundColor,
      arrowColor: arrowColor,
      arrowPadding: arrowPadding,
      arrowPosition: arrowPosition,
      arrowExpanded: arrowExpanded,
      arrow: arrow
  );

  final List<E> bodyChildren;

  final Widget Function(BuildContext context, E e) bodyItemBuilder;
}