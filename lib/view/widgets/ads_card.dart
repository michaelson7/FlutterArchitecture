import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/dark_img_widget.dart';

class AdsCard extends StatelessWidget {
  final AsyncSnapshot<AdsModel> snapshot;
  AdsCard(this.snapshot);

  @override
  Widget build(BuildContext context) {
    var modelData = snapshot.data!.adsModelList;

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: modelData.length,
      itemBuilder: (BuildContext context, int index) {
        return DarkImageWidget(
          height: 250,
          width: double.infinity,
          imgPath: modelData[index].imgPath,
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
                        modelData[index].header,
                        style: kTextStyleHeader.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        modelData[index].subHeader,
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
