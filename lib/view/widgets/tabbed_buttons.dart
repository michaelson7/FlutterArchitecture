import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:logger/logger.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

import 'horizontal_widget.dart';

class TabbedButtons extends StatefulWidget {
  final AsyncSnapshot<dynamic> snapshot;
  final Function(int) onSelectionUpdated;
  final int selectedIndex;

  TabbedButtons({
    required this.snapshot,
    required this.onSelectionUpdated,
    required this.selectedIndex,
  });

  @override
  _TabbedButtonsState createState() => _TabbedButtonsState();
}

class _TabbedButtonsState extends State<TabbedButtons> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var currentIndex = 0;
    bool shouldHighlight = false;
    var modelData = widget.snapshot.data!.categoryModelList;

    for (var data in modelData) {
      if (currentIndex <= 0) {
        setState(() => shouldHighlight = false);
      } else {
        setState(() => shouldHighlight = false);
      }
      var design = Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            minWidth: 80,
          ),
          child: Material(
            color: shouldHighlight
                ? kAccentColor
                : _colorPicker(
                    currentIndex: data.id,
                    selectedIndex: widget.selectedIndex,
                  ),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () async {
                _updateSelection(data.id, currentIndex);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: _invertTitle(
                    currentIndex: currentIndex,
                    selectedIndex: widget.selectedIndex,
                    title: data.title,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      widgetList.add(design);
      currentIndex++;
    }
    var horizontalList = horizontalWidgetBuilder(widgetList);
    return horizontalList;
  }

  _updateSelection(int index, currentIndx) {
    setState(() {
      widget.onSelectionUpdated(index);
    });
  }

  _colorPicker({required int currentIndex, required int selectedIndex}) {
    if (currentIndex == selectedIndex) {
      return kAccentColor;
    } else {
      return kCardBackground;
    }
  }

  _invertTitle(
      {required int currentIndex,
      required int selectedIndex,
      required String title}) {
    if (currentIndex == selectedIndex) {
      return InvertColors(
        child: Text(title),
      );
    } else {
      return Text(title);
    }
  }
}
