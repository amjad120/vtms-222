import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/components/CustomButton.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  TextEditingController vehicleName = TextEditingController();
  TextEditingController chassisNumber = TextEditingController();
  TextEditingController plateNumber = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController coverdDistance = TextEditingController();

  // قائمة أنواع المركبات المتاحة
  final List<String> vehicleTypes = ['car', 'truck', 'heavy equipment'];
  String? selectedVehicleType; // سيتم تخزين القيمة المحددة هنا

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  CollectionReference vehicle = FirebaseFirestore.instance.collection('vehicle');
  bool isLoading = false;

  addVehicle() async {
    if (formState.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });
        DocumentReference result = await vehicle.add({
          "user_id": FirebaseAuth.instance.currentUser!.uid,
          "v_name": vehicleName.text,
          "chassisNumber": chassisNumber.text,
          "plateNumber": plateNumber.text,
          "color": color.text,
          "vehicleType": selectedVehicleType, // استخدام القيمة المحددة من القائمة
          "coverdDistance": coverdDistance.text,
          "IsActive": true,
        });
        Navigator.of(context).pushReplacementNamed("homepage");
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print("Error $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add vehicle",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Form(
        key: formState,
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vehicle Information",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        Text(
                          "fill following fields to add vehicle",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                          height: 15,
                        ),
                        Text(
                          "Vehicle name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextField(
                            hintText: "Vehicle Name",
                            mycontroller: vehicleName,
                            validator: (val) {
                              if (val == "") return "Enter vehicle Name";
                            }),
                        Text(
                          "Vehicle type",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 10,
                        ),
                        // استبدال TextField بـ DropdownButtonFormField
                        DropdownButtonFormField<String>(
                           
                          decoration: InputDecoration(
                           border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(50),
                           borderSide: BorderSide(
                          
            ),
          ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                          ),
                          value: selectedVehicleType,
                          hint: Text('Select Vehicle Type'),
                          items: vehicleTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedVehicleType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select vehicle type';
                            }
                            return null;
                          },
                        ),
                        Text(
                          "Chassis Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextField(
                            hintText: "Chassis Number",
                            mycontroller: chassisNumber,
                            validator: (val) {
                              if (val == "") return "Enter chassis Number";
                            }),
                        Text(
                          "Plate Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextField(
                            hintText: "Plate Number",
                            mycontroller: plateNumber,
                            validator: (val) {
                              if (val == "") return "Enter plate Number";
                            }),
                        Text(
                          "Color",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextField(
                            hintText: "Color",
                            mycontroller: color,
                            validator: (val) {
                              if (val == "") return "Enter color";
                            }),
                        Text(
                          "Coverd Distance",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 10,
                        ),
                        CustomTextField(
                            hintText: "Coverd Distance",
                            mycontroller: coverdDistance,
                            validator: (val) {
                              if (val == "") return "Enter Coverd Distance";
                            }),
                        Container(
                          height: 10,
                        ),
                        Center(
                          child: CustomButton(
                              title: "add vehicle",
                              onPressed: () {
                                addVehicle();
                              }),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}