import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

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
        return Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kDarkCardBackground,
            image: DecorationImage(
              image: NetworkImage(modelData[index].imgPath),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    modelData[index].header,
                    style: kTextStyleHeader,
                  ),
                  SizedBox(height: 10),
                  Text(
                    modelData[index].subHeader,
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
