import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

class OrderCards extends StatelessWidget {
  const OrderCards({
    Key? key,
    required this.productData,
    required this.purchaseData,
    required this.function,
  }) : super(key: key);

  final ProductsModelList productData;
  final UserOrderModelList purchaseData;
  final Function function;

  @override
  Widget build(BuildContext context) {
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
                    imageUrl: productData.imgPath,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
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
                            purchaseData.status,
                            style: kTextStyleHeader,
                          ),
                          Text(
                            productData.name,
                            style: kTextStyleFaint,
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'ZMK ${purchaseData.total}',
                                  style: kTextStyleSubHeader,
                                ),
                              ),
                              Text(
                                purchaseData.timeStamp,
                                style: kTextStyleFaint,
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
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: kCardBackground,
            ),
          )
        ],
      ),
    );
  }
}
