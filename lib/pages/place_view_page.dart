import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twople/global.dart';
import 'package:twople/models/place_model.dart';
import 'package:twople/pages/booking_page.dart';

class PlaceViewPage extends StatefulWidget {
  final PlaceModel placeModel;
  const PlaceViewPage({Key? key, required this.placeModel}) : super(key: key);

  @override
  State<PlaceViewPage> createState() => _PlaceViewPageState();
}

class _PlaceViewPageState extends State<PlaceViewPage> {
  @override
  Widget build(BuildContext context) {
    var isBooked = bookedHotels.indexWhere(
      (element) => element.placeName == widget.placeModel.placeName,
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton(
        child: Text(isBooked == -1 ? "Book" : "Booked"),
        color: Colors.redAccent,
        onPressed: () {
          if (isBooked == -1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookingPage(placeModel: widget.placeModel)));
          }
        },
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: true,
            floating: true,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            expandedHeight: 400,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.up_arrow),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.heart),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(3, 3),
                        blurRadius: 7,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 150,
                      height: 200,
                      child: CachedNetworkImage(
                        imageUrl: widget.placeModel.placeImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                widget.placeModel.placeName,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                offset: const Offset(5, 5),
                                spreadRadius: 1,
                              )
                            ]),
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          widget.placeModel.placeDesc,
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        spacing: 10,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 7,
                                    offset: const Offset(5, 5),
                                    spreadRadius: 1,
                                  )
                                ]),
                            padding: const EdgeInsets.all(15),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      CupertinoIcons.home,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${widget.placeModel.placeType}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 7,
                                    offset: const Offset(5, 5),
                                    spreadRadius: 1,
                                  )
                                ]),
                            padding: const EdgeInsets.all(15),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const WidgetSpan(
                                    child: Icon(
                                      CupertinoIcons.money_dollar,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " ${widget.placeModel.placePrice}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
