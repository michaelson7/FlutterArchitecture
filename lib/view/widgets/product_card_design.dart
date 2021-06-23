import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/product_details_activity.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class ProductCardDesign extends StatefulWidget {
  final ProductsModelList data;
  final bool isGrid;
  bool isSaved;

  ProductCardDesign({
    required this.data,
    this.isGrid = false,
    this.isSaved = false,
  });

  @override
  _ProductCardDesignState createState() => _ProductCardDesignState();
}

class _ProductCardDesignState extends State<ProductCardDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          widget.isGrid ? EdgeInsets.only(right: 0) : EdgeInsets.only(right: 8),
      height: 260,
      width: 180,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductsDetails(widget.data)),
          );
        },
        child: Card(
          color: kCardBackground,
          elevation: 5,
          shadowColor: Color(0xfffff),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: kImageRadiusTop,
                  child: CachedNetworkImage(
                    width: double.infinity,
                    imageUrl: widget.data.imgPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.name,
                            maxLines: 1,
                          ),
                          Text(
                            'ZMK ${widget.data.price}',
                            style: kTextStyleFaint,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (!widget.isSaved) {
                            snackBarBuilder(
                              context: context,
                              message:
                                  '${widget.data.name}  Added to  Wishlist',
                            );
                            widget.isSaved = !widget.isSaved;
                          } else {
                            snackBarBuilder(
                              context: context,
                              message:
                                  '${widget.data.name}  Removed From Wishlist',
                            );
                            widget.isSaved = !widget.isSaved;
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: widget.isSaved ? kAccentColor : kIconColor,
                        ),
                      ),
                    )
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
