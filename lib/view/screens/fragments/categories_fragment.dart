import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/provider/category_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/category_products_activity.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class CategoryFragment extends StatefulWidget {
  @override
  _CategoryFragmentState createState() => _CategoryFragmentState();
}

class _CategoryFragmentState extends State<CategoryFragment> {
  CategoryProvider _categoryProvider = CategoryProvider();

  void initProviders() async {
    await _categoryProvider.getCategories();
  }

  @override
  void initState() {
    initProviders();
    super.initState();
  }

  @override
  void dispose() {
    _categoryProvider.endStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _categoryProvider.getStream,
          builder: (context, AsyncSnapshot<CategoryModel> snapshot) {
            if (snapshot.hasData) {
              return CategoryGrid(snapshot);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  CategoryGrid(this.snapshot);
  final AsyncSnapshot<CategoryModel> snapshot;

  @override
  Widget build(BuildContext context) {
    var data = snapshot.data!.categoryModelList;
    return Container(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: data.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(4.0),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProducts(
                    data[index],
                  ),
                ),
              );
            },
            child: DarkImageWidget(
              imgPath: data[index].imgPath,
              borderRadius: kBorderRadiusCircular,
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data[index].title,
                          style: kTextStyleHeader.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
