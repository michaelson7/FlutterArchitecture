import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';

class AdsCard extends StatelessWidget {
  final AdsModel? snapshot;
  int page;
  AdsCard({this.snapshot, required this.page});

  @override
  Widget build(BuildContext context) {
    var modelData = snapshot!.adsModelList[page];
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return DarkImageWidget(
          height: 250,
          width: double.infinity,
          imgPath: modelData.imgPath,
          borderRadius: kBorderRadiusCircular,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        modelData.header,
                        style: kTextStyleHeader.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        modelData.subHeader,
                        style: TextStyle(color: Colors.white),
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
