import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/product_details.dart';

class ProductCardDesign extends StatelessWidget {
  final ProductsModelList data;
  final bool isGrid;
  ProductCardDesign({
    required this.data,
    this.isGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isGrid ? EdgeInsets.only(right: 0) : EdgeInsets.only(right: 8),
      height: 260,
      width: 180,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductsDetails(data)),
          );
        },
        child: Card(
          color: kDarkCardBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: kImageRadiusTop,
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: data.imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      maxLines: 1,
                    ),
                    Text(
                      'ZMK ${data.price}',
                      style: kTextStyleFaint,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
