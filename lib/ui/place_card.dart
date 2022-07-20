import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twople/models/place_model.dart';
import 'package:twople/pages/place_view_page.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel placeModel;
  const PlaceCard({Key? key, required this.placeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: ((context) =>
                      PlaceViewPage(placeModel: placeModel))));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: placeModel.placeImg,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white70,
                child: ListTile(
                  dense: true,
                  title: Text(placeModel.placeName),
                  subtitle: Text(placeModel.placeType),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
