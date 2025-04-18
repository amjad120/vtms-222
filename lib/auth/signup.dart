import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomButton.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}



class _SignupState extends State<Signup> {
  TextEditingController username = TextEditingController();
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
 
   CollectionReference user = FirebaseFirestore.instance.collection('user');
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'images/image.png',
                    height: 300,
                  ),
                ),
                Text(
                  "Sign up",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "Sign up continue using the app",
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  height: 15,
                ),
                Text(
                  "User name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Enter User name",
                  mycontroller: username,
                  validator: (val) {
                    if (val == "") return "Fill user name field";
                  },
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "First name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Enter First name",
                  mycontroller: firstname,
                  validator: (val) {
                    if (val == "") return "Fill first name field";
                  },
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Last name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Enter Last name",
                  mycontroller: lastname,
                  validator: (val) {
                    if (val == "") return "Fill last name field";
                  },
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Phone",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Enter your phone",
                  mycontroller: phone,
                  validator: (val) {
                    if (val == "") return "Fill phone field";
                  },
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Enter your email",
                  mycontroller: email,
                  validator: (val) {
                    if (val == "") return "Fill email field";
                  },
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(
                  height: 10,
                ),
                CustomTextField(
                  hintText: "Enter password",
                  mycontroller: password,
                  validator: (val) {
                    if (val == "") return "Fill password field";
                  },
                ),
                Container(
                    padding: EdgeInsets.only(right: 4),
                    alignment: Alignment.topRight,
                    margin: EdgeInsets.only(top: 10, bottom: 30),
                    child: const Text(
                      "Forget password?",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )),
              ],
            ),
          ),
          CustomButton(
              title: "Sign up",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
           await user.add({
          "user_id": FirebaseAuth.instance.currentUser!.uid,
          "firstname": firstname.text,
          "lastname": lastname.text,
          "email": email.text,
        //  "password": password.text, حذفتها عشان الخصوصية
          "phone": phone.text,
          "username": username.text,
          'created_at': FieldValue.serverTimestamp(),
        });
                    
                    await FirebaseAuth.instance.signOut();
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.rightSlide,
                      title: 'Success',
                      desc: 'Account created successfully!',
                    ).show();
                    Future.delayed(Duration(seconds: 3), () {
                     
                      Navigator.of(context).pushReplacementNamed("login");
                    });
                  } on FirebaseAuthException catch (e) {
                    String errorMessage = "";

                    if (e.code == 'weak-password') {
                      errorMessage = 'The password provided is too weak.';
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The account already exists for that email.',
                      ).show();
                    } else if (e.code == 'invalid-email') {
                      errorMessage = 'Invalid email format.';
                    } else {
                      errorMessage =
                          'An unexpected error occurred: ${e.message}';
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }
                }
              }),
          Container(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You already have an account? ",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("login");
                },
                child: Text(
                  " Login page",
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
