import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/product_details_activity.dart';

class ProductCardDesign extends StatefulWidget {
  final ProductsModelList data;
  final bool isGrid;
  Color color;

  ProductCardDesign({
    required this.data,
    this.isGrid = false,
    this.color = Colors.white,
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
          color: kDarkCardBackground,
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
                        var snackBar;
                        setState(() {
                          if (widget.color == Colors.white) {
                            snackBar = SnackBar(
                              content:
                                  Text('${widget.data.name} Added to Wishlist'),
                            );
                            widget.color = kAccentColor;
                          } else {
                            snackBar = SnackBar(
                              content: Text(
                                  '${widget.data.name}  Removed From Wishlist'),
                            );
                            widget.color = Colors.white;
                          }
                        });
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          FontAwesomeIcons.heart,
                          color: widget.color,
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
