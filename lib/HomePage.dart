import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/AboutUs.dart';
import 'package:flutter_application_1/ProfilePage.dart';
import 'package:flutter_application_1/ReportPage.dart';
import 'package:flutter_application_1/action/scanOBD2_Only.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/vehicleList.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';



class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLoading = true;

  int selectedIndex = 0; // for bottom bars transfer

  List<QueryDocumentSnapshot> vechile_data = [];
  getVechileData() async {
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('vehicle')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    isLoading = false;
    vechile_data.addAll(querySnapshot1.docs);
    setState(() {});
  }

  @override
  void initState() {
    getVechileData();
    super.initState();
  }

   List<Widget> get pagelist => [
        Vehiclelist(vechile_data: vechile_data),
        const ProfilePage(),
        const scanOBD2_Only(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {
          Navigator.of(context).pushNamed("addVehicle");
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedFontSize: 15,
        onTap: (value) {
            setState(() {
    selectedIndex = value;
  });
        },
        selectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedFontSize: 15,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_sharp), label: "Track"),
          BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle_outlined), label: "Scan"),
        ],
      ),
      appBar: AppBar(
        title: const Text(("home page"),
            style: TextStyle(
              fontSize: 30,
            )),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : pagelist[selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 80),
          children: [
            ListTile(
              leading: const Icon(
                Icons.person,
                size: 30,
              ),
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.folder_copy_rounded,
                size: 30,
              ),
              title: const Text(
                "Report",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReportPage()));
              },
            ),
       ListTile(
  leading: Icon(Icons.dark_mode, size: 30),
  title: Text("Dark mode", style: TextStyle(fontSize: 18)),
  trailing: Switch(
  value: Provider.of<ThemeNotifier>(context).isDarkMode,
  onChanged: (value) {
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
  },
),
  onTap: () {
    Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
  },
),
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                size: 30,
              ),
              title: const Text(
                "About us",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_sharp,
                size: 30,
              ),
              title: const Text(
                "Log out",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Warning"),
                      content: const Text("are you sure to log out?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("cancel")),
                        TextButton(
                            onPressed: () async {
                              GoogleSignIn googleSignIn = GoogleSignIn();
                              googleSignIn.disconnect();
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "login", (route) => false);
                            },
                            child: const Text("yes")),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
