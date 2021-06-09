import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

class StackedProductCard extends StatelessWidget {
  final AsyncSnapshot<ProductsModel> snapshot;
  StackedProductCard(this.snapshot);

  @override
  Widget build(BuildContext context) {
    var modelData = snapshot.data!.productsModelList;
    return ListView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width: double.infinity,
          height: 200,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kDarkCardBackgroundFaint,
          ),
          child: Expanded(
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: modelData[index].imgPath,
                        fit: BoxFit.cover,
                        width: 155,
                        height: 130,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            modelData[index].name,
                            style: kTextStyleSubHeader,
                          ),
                          SizedBox(height: 10),
                          Text(
                            modelData[index].description,
                            style: kTextStyleFaint,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'ZMK ${modelData[index].price.toString()}',
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('BUY NOW!'),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
