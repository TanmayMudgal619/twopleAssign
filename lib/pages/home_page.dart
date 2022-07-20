import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:twople/global.dart';
import 'package:twople/models/place_model.dart';
import 'package:twople/pages/explore_page.dart';
import 'package:twople/pages/login_page.dart';
import 'package:twople/ui/place_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.compass),
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bookmark),
            ),
          ],
        ),
        tabBuilder: ((context, index) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text((index == 0) ? "Explore" : "Booked"),
              trailing: (index == 0)
                  ? TextButton(
                      child: Text("Sign Out"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().whenComplete(() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        });
                      },
                    )
                  : null,
            ),
            child: (index == 0)
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ExplorePage(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("bookings")
                          .where(
                            "userId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Error: ${snapshot.error.toString()}"),
                          );
                        }
                        if (snapshot.hasData) {
                          var data = fromFbToHm(snapshot.requireData.docs);
                          data.forEach((element) {
                            bookedHotels.clear();
                            bookedHotels.add(element);
                          });
                          return GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 5,
                            children: data
                                .map((e) => PlaceCard(placeModel: e))
                                .toList(),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
          );
        }),
      ),
    );
  }
}
