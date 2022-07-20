import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twople/models/place_model.dart';

class BookingPage extends StatefulWidget {
  final PlaceModel placeModel;
  const BookingPage({Key? key, required this.placeModel}) : super(key: key);
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _dateTime = DateTime.now().add(const Duration(days: 1));
  GlobalKey<ScaffoldState> _ss = GlobalKey<ScaffoldState>();
  bool _booking = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _ss,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton(
        color: Colors.redAccent,
        onPressed: () async {
          setState(() {
            _booking = true;
          });
          try {
            await FirebaseFirestore.instance.collection("bookings").add({
              "placeAddress": widget.placeModel.placeAddress,
              "placeDesc": widget.placeModel.placeDesc,
              "placeImg": widget.placeModel.placeImg,
              "placeType": widget.placeModel.placeType,
              "placeName": widget.placeModel.placeName,
              "placePrice": widget.placeModel.placePrice,
              "placeId": widget.placeModel.placeId,
              "userId": FirebaseAuth.instance.currentUser!.uid,
              "bookedTime": _dateTime.toString().substring(0, 10),
            }).whenComplete(() => setState(() {
                  _booking = false;
                }));
            _ss.currentState!.showSnackBar(
                const SnackBar(content: ListTile(title: Text("Booked"))));
            Navigator.pop(context);
          } catch (e) {
            _ss.currentState!.showSnackBar(const SnackBar(
                content: ListTile(title: Text("Error Occurred"))));
          }
        },
        child: (_booking)
            ? (const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ))
            : (const Text("Book")),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: kToolbarHeight,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: const Offset(3, 3),
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
                const SizedBox(
                  height: 30,
                ),
                Text(
                  widget.placeModel.placeName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select A Day",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 100,
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
                          ],
                        ),
                        child: CupertinoDatePicker(
                          onDateTimeChanged: (date) {
                            _dateTime = date;
                          },
                          initialDateTime: _dateTime,
                          minimumDate: DateTime.now(),
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Price",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                          ],
                        ),
                        child: ListTile(
                          title: const Text("Total Price:"),
                          trailing: Text("Rs.${widget.placeModel.placePrice}"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
