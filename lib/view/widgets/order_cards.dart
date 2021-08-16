import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

class OrderCards extends StatelessWidget {
  const OrderCards({
    Key? key,
    this.productData,
    required this.function,
  }) : super(key: key);

  final ProductsModel? productData;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productData!.size,
      itemBuilder: (BuildContext context, int index) {
        var data = productData!.productsModelList[index];
        return Container(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  function();
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: kBorderRadiusCircular,
                      child: CachedNetworkImage(
                        imageUrl: data.imgPath,
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: kTextStyleSubHeader,
                              ),
                              Text(
                                "qty: ${data.quantity.toString()}",
                                style: kTextStyleFaint,
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ZMK ${data.price}',
                                      style: kTextStyleSubHeader,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Divider(
                  color: kCardBackground,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
