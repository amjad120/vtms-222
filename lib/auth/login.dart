import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomButton.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

Future signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = 
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in to Firebase with the Google credentials
    final UserCredential userCredential = 
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Get the user data from Google
    final User? user = userCredential.user;
    
    // Check if this is a new user (first time signing in with Google)
    if (userCredential.additionalUserInfo!.isNewUser) {
      // Create a new document in Firestore for this user
      await FirebaseFirestore.instance.collection('user').doc(user?.uid).set({
        'user_id': user?.uid,
        'username': user?.displayName ?? '',
        'email': user?.email ?? '',
        'firstname': user?.displayName?.split(' ').first ?? '',
        'lastname': user?.displayName?.split(' ').last ?? '',
        'phone': user?.phoneNumber ?? '',
        'created_at': FieldValue.serverTimestamp(),
      });
    }

    // Navigate to the homepage
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  } catch (e) {
    print("Error signing in with Google: $e");
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: 'Failed to sign in with Google. Please try again.',
    ).show();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:isLoading == true? Center(child: CircularProgressIndicator(),): Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('images/image.png'),
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "Login to continue using the app",
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  height: 15,
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
                InkWell(
                  onTap: () async {
                    if (email.text == "") {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc:
                            'please enter your email in Email field,then click on forget password',
                      ).show();
                      return;
                    }
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'Warning',
                        desc:
                            'we send link to your email, please check your email reset your password ',
                      ).show();
                    } catch (e) {
                      print(e);
                      //فيه مشكلة ما تشتغل ما ادري ليه بس
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'Warning',
                        desc: 'Make sure your email is correct!',
                      ).show();
                    }
                  },
                  child: Container(
                      padding: EdgeInsets.only(right: 4),
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 10, bottom: 30),
                      child: const Text(
                        "Forget password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                ),
              ],
            ),
          ),
          CustomButton(
              title: "Login",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    isLoading = true;
                    setState(() {});
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    isLoading = false;
                    setState(() {
                      
                    });
                    if (userCredential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("homepage");
                    } else {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Warning',
                        desc:
                            ' your email not verify yet, check your email to verify this email',
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    isLoading = false;
                    setState(() {
                      
                    });
                    if (e.code == 'invalid-credential') {
                      print('Wrong password provided for that user');
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Wrong email or password !',
                      ).show();
                    }
                    print("FirebaseAuthException: ${e.code} - ${e.message}");
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields!")),
                  );
                }
              }),
          Container(
            height: 20,
          ),
          Center(
              child: Text(
            "Or Login with",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
          Container(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              signInWithGoogle();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/google.png',
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Google",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                )
              ],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: const Color.fromARGB(255, 242, 240, 240),
            height: 50,
          ),
          Container(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed("signup");
                },
                child: Text(
                  " Register here",
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
