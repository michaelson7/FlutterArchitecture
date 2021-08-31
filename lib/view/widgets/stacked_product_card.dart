import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

import '../../provider/cart_provider.dart';
import '../screens/activities/product_details_activity.dart';
import 'snack_bar_builder.dart';

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
          height: 150,
          margin: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kCardBackgroundFaint,
          ),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductsDetails(modelData[index]),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: modelData[index].imgPath,
                              fit: BoxFit.cover,
                              width: 110,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
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
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ZMK ${modelData[index].price.toString()}',
                                    ),
                                  ),
                                  Material(
                                    borderRadius: kBorderRadiusCircular,
                                    color: kAccentColor,
                                    child: IconButton(
                                      icon: Icon(Icons.add_shopping_cart),
                                      onPressed: () {
                                        var message;
                                        if (Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        ).addToCart(modelData[index])) {
                                          message =
                                              '${modelData[index].name}added to cart';
                                        } else {
                                          message = 'error, check logs';
                                        }
                                        snackBarBuilder(
                                            message: message, context: context);
                                      },
                                    ),
                                  ),
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
            ],
          ),
        );
      },
    );
  }
}
