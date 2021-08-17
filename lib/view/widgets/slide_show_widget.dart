import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';

import 'dark_img_widget.dart';

class SlideShowWidget extends StatelessWidget {
  final AsyncSnapshot<ProductsModel> snapshot;
  final List<String> imgList = [];

  SlideShowWidget({required this.snapshot}) {
    var data = snapshot.data!.productsModelList;
    int i = 0;
    for (var imgData in data) {
      if (i < 5) {
        imgList.add(imgData.imgPath);
        i++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 400,
        viewportFraction: 0.9,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 900),
      ),
      items: imgList
          .map(
            (item) => DarkImageWidget(
              imgPath: item,
              width: double.infinity,
            ),
          )
          .toList(),
    );
  }
}
