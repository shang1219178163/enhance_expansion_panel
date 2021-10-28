
import 'package:flutter/material.dart';
import 'enhance_expand_icon.dart';

// import 'constants.dart';
// import 'expand_icon.dart';
// import 'ink_well.dart';
// import 'material_localizations.dart';
// import 'mergeable_material.dart';
// import 'shadows.dart';
// import 'theme.dart';
const double _kPanelHeaderCollapsedHeight = kMinInteractiveDimension;
const EdgeInsets _kPanelHeaderExpandedDefaultPadding = EdgeInsets.symmetric(
  vertical: 64.0 - _kPanelHeaderCollapsedHeight,
);

class _SaltedEnhanceKey<S, V> extends LocalKey {
  const _SaltedEnhanceKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is _SaltedEnhanceKey<S, V>
        && other.salt == salt
        && other.value == value;
  }

  @override
  int get hashCode => hashValues(runtimeType, salt, value);

  @override
  String toString() {
    final String saltString = S == String ? "<'$salt'>" : '<$salt>';
    final String valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}


enum EnhanceExpansionPanelArrowPosition {
  /// A horizontal layout of the Arrow.
  leading,
  /// A horizontal layout of the Arrow.
  tailing,
}


class EnhanceExpansionPanel {
  /// Creates an expansion panel to be used as a child for [EnhanceExpansionPanelList].
  /// See [EnhanceExpansionPanelList] for an example on how to use this widget.
  ///
  /// The [headerBuilder], [body], and [isExpanded] arguments must not be null.
  EnhanceExpansionPanel({
    required this.headerBuilder,
    required this.body,
    this.isExpanded = false,
    this.canTapOnHeader = false,
    this.backgroundColor,
    this.arrowHide = false,
    this.arrowColor = Colors.black54,
    this.arrowPadding,
    this.arrowPosition = EnhanceExpansionPanelArrowPosition.tailing,
    this.arrowExpanded,
    this.arrow,
  }) : assert(headerBuilder != null),
        assert(body != null),
        assert(isExpanded != null),
        assert(canTapOnHeader != null);

  /// The widget builder that builds the expansion panels' header.
  final ExpansionPanelHeaderBuilder headerBuilder;

  /// The body of the expansion panel that's displayed below the header.
  ///
  /// This widget is visible only when the panel is expanded.
  final Widget body;

  /// Whether the panel is expanded.
  ///
  /// Defaults to false.
  final bool isExpanded;

  /// Whether tapping on the panel's header will expand/collapse it.
  ///
  /// Defaults to false.
  final bool canTapOnHeader;

  /// Defines the background color of the panel.
  ///
  /// Defaults to [ThemeData.cardColor].
  final Color? backgroundColor;

  final bool arrowHide;

  final Color? arrowColor;

  final EnhanceExpansionPanelArrowPosition arrowPosition;

  final EdgeInsetsGeometry? arrowPadding;

  final Widget? arrow;

  final Widget? arrowExpanded;

}

/// An expansion panel that allows for radio-like functionality.
/// This means that at any given time, at most, one [EnhanceExpansionPanelRadio]
/// can remain expanded.
///
/// A unique identifier [value] must be assigned to each panel.
/// This identifier allows the [EnhanceExpansionPanelList] to determine
/// which [EnhanceExpansionPanelRadio] instance should be expanded.
///
/// See [EnhanceExpansionPanelList.radio] for a sample implementation.
class EnhanceExpansionPanelRadio extends EnhanceExpansionPanel {

  /// An expansion panel that allows for radio functionality.
  ///
  /// A unique [value] must be passed into the constructor. The
  /// [headerBuilder], [body], [value] must not be null.
  EnhanceExpansionPanelRadio({
    required this.value,
    required ExpansionPanelHeaderBuilder headerBuilder,
    required Widget body,
    bool canTapOnHeader = false,
    Color? backgroundColor,
  }) : assert(value != null),
        super(
        body: body,
        headerBuilder: headerBuilder,
        canTapOnHeader: canTapOnHeader,
        backgroundColor: backgroundColor,
      );

  /// The value that uniquely identifies a radio panel so that the currently
  /// selected radio panel can be identified.
  final Object value;
}

/// A material expansion panel list that lays out its children and animates
/// expansions.
///
/// Note that [expansionCallback] behaves differently for [EnhanceExpansionPanelList]
/// and [EnhanceExpansionPanelList.radio].
///
/// {@tool dartpad --template=stateful_widget_scaffold}
///
/// Here is a simple example of how to implement EnhanceExpansionPanelList.
///
/// ```dart preamble
/// // stores EnhanceExpansionPanel state information
/// class Item {
///   Item({
///     required this.expandedValue,
///     required this.headerValue,
///     this.isExpanded = false,
///   });
///
///   String expandedValue;
///   String headerValue;
///   bool isExpanded;
/// }
///
/// List<Item> generateItems(int numberOfItems) {
///   return List<Item>.generate(numberOfItems, (int index) {
///     return Item(
///       headerValue: 'Panel $index',
///       expandedValue: 'This is item number $index',
///     );
///   });
/// }
/// ```
///
/// ```dart
/// final List<Item> _data = generateItems(8);
///
/// @override
/// Widget build(BuildContext context) {
///   return SingleChildScrollView(
///     child: Container(
///       child: _buildPanel(),
///     ),
///   );
/// }
///
/// Widget _buildPanel() {
///   return EnhanceExpansionPanelList(
///     expansionCallback: (int index, bool isExpanded) {
///       setState(() {
///         _data[index].isExpanded = !isExpanded;
///       });
///     },
///     children: _data.map<EnhanceExpansionPanel>((Item item) {
///       return EnhanceExpansionPanel(
///         headerBuilder: (BuildContext context, bool isExpanded) {
///           return ListTile(
///             title: Text(item.headerValue),
///           );
///         },
///         body: ListTile(
///           title: Text(item.expandedValue),
///           subtitle: const Text('To delete this panel, tap the trash can icon'),
///           trailing: const Icon(Icons.delete),
///           onTap: () {
///             setState(() {
///               _data.removeWhere((Item currentItem) => item == currentItem);
///             });
///           }
///         ),
///         isExpanded: item.isExpanded,
///       );
///     }).toList(),
///   );
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [EnhanceExpansionPanel]
///  * [EnhanceExpansionPanelList.radio]
///  * <https://material.io/design/components/lists.html#types>
class EnhanceExpansionPanelList extends StatefulWidget {
  /// Creates an expansion panel list widget. The [expansionCallback] is
  /// triggered when an expansion panel expand/collapse button is pushed.
  ///
  /// The [children] and [animationDuration] arguments must not be null.
  const EnhanceExpansionPanelList({
    Key? key,
    this.children = const <EnhanceExpansionPanel>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
  }) : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = false,
        initialOpenPanelValue = null,
        super(key: key);

  /// Creates a radio expansion panel list widget.
  ///
  /// This widget allows for at most one panel in the list to be open.
  /// The expansion panel callback is triggered when an expansion panel
  /// expand/collapse button is pushed. The [children] and [animationDuration]
  /// arguments must not be null. The [children] objects must be instances
  /// of [EnhanceExpansionPanelRadio].
  ///
  /// {@tool dartpad --template=stateful_widget_scaffold}
  ///
  /// Here is a simple example of how to implement EnhanceExpansionPanelList.radio.
  ///
  /// ```dart preamble
  /// // stores EnhanceExpansionPanel state information
  /// class Item {
  ///   Item({
  ///     required this.id,
  ///     required this.expandedValue,
  ///     required this.headerValue,
  ///   });
  ///
  ///   int id;
  ///   String expandedValue;
  ///   String headerValue;
  /// }
  ///
  /// List<Item> generateItems(int numberOfItems) {
  ///   return List<Item>.generate(numberOfItems, (int index) {
  ///     return Item(
  ///       id: index,
  ///       headerValue: 'Panel $index',
  ///       expandedValue: 'This is item number $index',
  ///     );
  ///   });
  /// }
  /// ```
  ///
  /// ```dart
  /// final List<Item> _data = generateItems(8);
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///   return SingleChildScrollView(
  ///     child: Container(
  ///       child: _buildPanel(),
  ///     ),
  ///   );
  /// }
  ///
  /// Widget _buildPanel() {
  ///   return EnhanceExpansionPanelList.radio(
  ///     initialOpenPanelValue: 2,
  ///     children: _data.map<EnhanceExpansionPanelRadio>((Item item) {
  ///       return EnhanceExpansionPanelRadio(
  ///         value: item.id,
  ///         headerBuilder: (BuildContext context, bool isExpanded) {
  ///           return ListTile(
  ///             title: Text(item.headerValue),
  ///           );
  ///         },
  ///         body: ListTile(
  ///           title: Text(item.expandedValue),
  ///           subtitle: const Text('To delete this panel, tap the trash can icon'),
  ///           trailing: const Icon(Icons.delete),
  ///           onTap: () {
  ///             setState(() {
  ///               _data.removeWhere((Item currentItem) => item == currentItem);
  ///             });
  ///           }
  ///         )
  ///       );
  ///     }).toList(),
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  const EnhanceExpansionPanelList.radio({
    Key? key,
    this.children = const <EnhanceExpansionPanelRadio>[],
    this.expansionCallback,
    this.animationDuration = kThemeAnimationDuration,
    this.initialOpenPanelValue,
    this.expandedHeaderPadding = _kPanelHeaderExpandedDefaultPadding,
    this.dividerColor,
    this.elevation = 2,
  }) : assert(children != null),
        assert(animationDuration != null),
        _allowOnlyOnePanelOpen = true,
        super(key: key);

  /// The children of the expansion panel list. They are laid out in a similar
  /// fashion to [ListBody].
  final List<EnhanceExpansionPanel> children;

  /// The callback that gets called whenever one of the expand/collapse buttons
  /// is pressed. The arguments passed to the callback are the index of the
  /// pressed panel and whether the panel is currently expanded or not.
  ///
  /// If EnhanceExpansionPanelList.radio is used, the callback may be called a
  /// second time if a different panel was previously open. The arguments
  /// passed to the second callback are the index of the panel that will close
  /// and false, marking that it will be closed.
  ///
  /// For EnhanceExpansionPanelList, the callback needs to setState when it's notified
  /// about the closing/opening panel. On the other hand, the callback for
  /// EnhanceExpansionPanelList.radio is simply meant to inform the parent widget of
  /// changes, as the radio panels' open/close states are managed internally.
  ///
  /// This callback is useful in order to keep track of the expanded/collapsed
  /// panels in a parent widget that may need to react to these changes.
  final ExpansionPanelCallback? expansionCallback;

  /// The duration of the expansion animation.
  final Duration animationDuration;

  // Whether multiple panels can be open simultaneously
  final bool _allowOnlyOnePanelOpen;

  /// The value of the panel that initially begins open. (This value is
  /// only used when initializing with the [EnhanceExpansionPanelList.radio]
  /// constructor.)
  final Object? initialOpenPanelValue;

  /// The padding that surrounds the panel header when expanded.
  ///
  /// By default, 16px of space is added to the header vertically (above and below)
  /// during expansion.
  final EdgeInsets expandedHeaderPadding;

  /// Defines color for the divider when [EnhanceExpansionPanel.isExpanded] is false.
  ///
  /// If `dividerColor` is null, then [DividerThemeData.color] is used. If that
  /// is null, then [ThemeData.dividerColor] is used.
  final Color? dividerColor;

  /// Defines elevation for the [EnhanceExpansionPanel] while it's expanded.
  ///
  /// By default, the value of elevation is 2.
  final double elevation;

  @override
  State<StatefulWidget> createState() => _EnhanceExpansionPanelListState();
}

class _EnhanceExpansionPanelListState extends State<EnhanceExpansionPanelList> {
  EnhanceExpansionPanelRadio? _currentOpenPanel;

  @override
  void initState() {
    super.initState();
    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All EnhanceExpansionPanelRadio identifier values must be unique.');
      if (widget.initialOpenPanelValue != null) {
        _currentOpenPanel =
            searchPanelByValue(widget.children.cast<EnhanceExpansionPanelRadio>(), widget.initialOpenPanelValue);
      }
    }
  }

  @override
  void didUpdateWidget(EnhanceExpansionPanelList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget._allowOnlyOnePanelOpen) {
      assert(_allIdentifiersUnique(), 'All EnhanceExpansionPanelRadio identifier values must be unique.');
      // If the previous widget was non-radio EnhanceExpansionPanelList, initialize the
      // open panel to widget.initialOpenPanelValue
      if (!oldWidget._allowOnlyOnePanelOpen) {
        _currentOpenPanel =
            searchPanelByValue(widget.children.cast<EnhanceExpansionPanelRadio>(), widget.initialOpenPanelValue);
      }
    } else {
      _currentOpenPanel = null;
    }
  }

  bool _allIdentifiersUnique() {
    final Map<Object, bool> identifierMap = <Object, bool>{};
    for (final EnhanceExpansionPanelRadio child in widget.children.cast<EnhanceExpansionPanelRadio>()) {
      identifierMap[child.value] = true;
    }
    return identifierMap.length == widget.children.length;
  }

  bool _isChildExpanded(int index) {
    if (widget._allowOnlyOnePanelOpen) {
      final EnhanceExpansionPanelRadio radioWidget = widget.children[index] as EnhanceExpansionPanelRadio;
      return _currentOpenPanel?.value == radioWidget.value;
    }
    return widget.children[index].isExpanded;
  }

  void _handlePressed(bool isExpanded, int index) {
    widget.expansionCallback?.call(index, isExpanded);

    if (widget._allowOnlyOnePanelOpen) {
      final EnhanceExpansionPanelRadio pressedChild = widget.children[index] as EnhanceExpansionPanelRadio;

      // If another EnhanceExpansionPanelRadio was already open, apply its
      // expansionCallback (if any) to false, because it's closing.
      for (int childIndex = 0; childIndex < widget.children.length; childIndex += 1) {
        final EnhanceExpansionPanelRadio child = widget.children[childIndex] as EnhanceExpansionPanelRadio;
        if (widget.expansionCallback != null &&
            childIndex != index &&
            child.value == _currentOpenPanel?.value)
          widget.expansionCallback!(childIndex, false);
      }

      setState(() {
        _currentOpenPanel = isExpanded ? null : pressedChild;
      });
    }
  }

  EnhanceExpansionPanelRadio? searchPanelByValue(List<EnhanceExpansionPanelRadio> panels, Object? value)  {
    for (final EnhanceExpansionPanelRadio panel in panels) {
      if (panel.value == value)
        return panel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(kElevationToShadow.containsKey(widget.elevation),
    'Invalid value for elevation. See the kElevationToShadow constant for'
        ' possible elevation values.',
    );

    final List<MergeableMaterialItem> items = <MergeableMaterialItem>[];

    for (int index = 0; index < widget.children.length; index += 1) {
      if (_isChildExpanded(index) && index != 0 && !_isChildExpanded(index - 1))
        items.add(MaterialGap(key: _SaltedEnhanceKey<BuildContext, int>(context, index * 2 - 1)));

      final EnhanceExpansionPanel child = widget.children[index];
      final Widget headerWidget = child.headerBuilder(
        context,
        _isChildExpanded(index),
      );

      Widget expandIconContainer = child.arrowHide ? Container() : Container(
        margin: const EdgeInsetsDirectional.only(end: 8.0),
        child: EnhanceExpandIcon(
          arrow: child.arrow,
          arrowExpanded: child.arrowExpanded,
          color: child.arrowColor,
          isExpanded: _isChildExpanded(index),
          padding: child.arrowPadding ?? const EdgeInsets.all(16.0),
          onPressed: !child.canTapOnHeader
              ? (bool isExpanded) => _handlePressed(isExpanded, index)
              : null,
        ),
      );
      if (!child.canTapOnHeader) {
        final MaterialLocalizations localizations = MaterialLocalizations.of(context);
        expandIconContainer = Semantics(
          label: _isChildExpanded(index)? localizations.expandedIconTapHint : localizations.collapsedIconTapHint,
          container: true,
          child: expandIconContainer,
        );
      }
      Widget header = Row(
        children: <Widget>[
          if (child.arrowHide == false && child.arrowPosition == EnhanceExpansionPanelArrowPosition.leading) expandIconContainer,
          Expanded(
            child: AnimatedContainer(
              duration: widget.animationDuration,
              curve: Curves.fastOutSlowIn,
              margin: _isChildExpanded(index) ? widget.expandedHeaderPadding : EdgeInsets.zero,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _kPanelHeaderCollapsedHeight),
                child: headerWidget,
              ),
            ),
          ),
          if (child.arrowHide == false && child.arrowPosition == EnhanceExpansionPanelArrowPosition.tailing) expandIconContainer,
        ],
      );
      if (child.canTapOnHeader) {
        header = MergeSemantics(
          child: InkWell(
            onTap: () => _handlePressed(_isChildExpanded(index), index),
            child: header,
          ),
        );
      }
      items.add(
        MaterialSlice(
          key: _SaltedEnhanceKey<BuildContext, int>(context, index * 2),
          color: child.backgroundColor,
          child: Column(
            children: <Widget>[
              header,
              AnimatedCrossFade(
                firstChild: Container(height: 0.0),
                secondChild: child.body,
                firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: _isChildExpanded(index) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: widget.animationDuration,
              ),
            ],
          ),
        ),
      );

      if (_isChildExpanded(index) && index != widget.children.length - 1)
        items.add(MaterialGap(key: _SaltedEnhanceKey<BuildContext, int>(context, index * 2 + 1)));
    }

    return MergeableMaterial(
      hasDividers: true,
      dividerColor: widget.dividerColor,
      elevation: widget.elevation,
      children: items,
    );
  }
}
