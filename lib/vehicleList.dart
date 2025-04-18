import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/vehicleCard.dart';


class Vehiclelist extends StatelessWidget {
  final List<QueryDocumentSnapshot> vechile_data;
  const Vehiclelist({super.key, required this.vechile_data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: vechile_data.length,
      itemBuilder: (context, i) {
        return InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Warning"),
                  content: const Text("are you sure to delete this vehicle?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("cancel")),
                    TextButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('vehicle')
                              .doc(vechile_data[i].id)
                              .delete();
                          Navigator.of(context)
                              .pushReplacementNamed("homepage");
                        },
                        child: const Text("yes")),
                  ],
                );
              },
            );
          },
          child: Vehiclecard(
            docid: "${vechile_data[i].id}",
            vehicleName: "${vechile_data[i]["v_name"]}",
            chassisNumber: "${vechile_data[i]["chassisNumber"]}",
            plateNumber: "${vechile_data[i]["plateNumber"]}",
            color: "${vechile_data[i]["color"]}",
            vehicleType: "${vechile_data[i]["vehicleType"]}",
            coverdDistance: "${vechile_data[i]["coverdDistance"]}",
          ),
        );
      },
 
    );
  }
}
