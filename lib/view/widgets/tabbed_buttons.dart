import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

import 'horizontal_widget.dart';

class TabbedButtons extends StatelessWidget {
  final AsyncSnapshot<CategoryModel> snapshot;
  TabbedButtons(this.snapshot);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    var modelData = snapshot.data!.categoryModelList;

    for (var data in modelData) {
      var design = Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: ConstrainedBox(
          constraints: new BoxConstraints(
            minWidth: 80,
          ),
          child: Material(
            color: kDarkCardBackground,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(data.name),
                ),
              ),
            ),
          ),
        ),
      );
      widgetList.add(design);
    }
    var horizontalList = horizontalWidgetBuilder(widgetList);
    return horizontalList;
  }
}
