import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomButton.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController username = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  List<QueryDocumentSnapshot> userData = [];
  bool isLoading = true;

  getUserData() async {
    try {
      QuerySnapshot snapshot = await users
          .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData.addAll(snapshot.docs);
    
      if (userData.isNotEmpty) {
        setState(() {
          username.text = userData[0]["username"] ?? "";
          firstname.text = userData[0]["firstname"] ?? "";
          lastname.text = userData[0]["lastname"] ?? "";
          email.text = userData[0]["email"] ?? "";
          phone.text = userData[0]["phone"] ?? "";
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }

    isLoading = false;
    setState(() {});
  }

  updateUser() async {
    if (formState.currentState!.validate()) {
      try {
        await users.doc(userData[0].id).update({
          "username": username.text,
          "firstname": firstname.text,
          "lastname": lastname.text,
          "phone": phone.text,
        });
        Navigator.of(context).pushReplacementNamed("homepage");
      } catch (e) {
        print("Error updating user: $e");
      }
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page", style: TextStyle(fontSize: 30)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Form(
        key: formState,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Information",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const Text(
                          "Edit your personal information",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        const Text("Username", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Username",
                          mycontroller: username,
                          validator: (val) {
                            if (val == "") return "Enter username";
                            return null;
                          },
                        ),
                        const Text("First Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "First Name",
                          mycontroller: firstname,
                          validator: (val) {
                            if (val == "") return "Enter first name";
                            return null;
                          },
                        ),
                        const Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Last Name",
                          mycontroller: lastname,
                          validator: (val) {
                            if (val == "") return "Enter last name";
                            return null;
                          },
                        ),
                        const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: email,
                          enabled: false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            hintText: "Email",
                            filled: true,
                            fillColor: const Color.fromARGB(255, 235, 232, 232),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 235, 232, 232)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 235, 232, 232)),
                            ),
                          ),
                        ),
                        const Text("Phone", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: "Phone",
                          mycontroller: phone,
                          validator: (val) {
                            if (val == "") return "Enter phone number";
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomButton(
                            title: "Save",
                            onPressed: updateUser,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
