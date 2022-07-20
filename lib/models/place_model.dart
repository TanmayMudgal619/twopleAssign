import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PlaceModel {
  final String placeId;
  final String placeAddress;
  final String placeDesc;
  final String placeImg;
  final String placeType;
  final String placeName;
  final int placePrice;
  final String? bookedFor;

  const PlaceModel(
    this.placeId,
    this.placeAddress,
    this.placeDesc,
    this.placeImg,
    this.placeType,
    this.placeName,
    this.placePrice,
    this.bookedFor,
  );
  factory PlaceModel.fromFirebase(Map<String, dynamic> dataMap) {
    return PlaceModel(
      dataMap["placeId"],
      dataMap["placeAddress"],
      dataMap["placeDesc"],
      dataMap["placeImg"],
      dataMap["placeType"],
      dataMap["placeName"],
      dataMap["placePrice"],
      dataMap["bookedTime"],
    );
  }
}

List<PlaceModel> fromFbToHm(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> firebaseData) {
  return firebaseData.map((e) {
    var m = e.data();
    m.addAll({"placeId": e.id});
    return PlaceModel.fromFirebase(m);
  }).toList();
}
