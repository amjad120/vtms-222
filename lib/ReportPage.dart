import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ReportCard.dart';


class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;

  List<QueryDocumentSnapshot> Report_data = [];
  getReportData() async {
    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('report')
        .where("user_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    isLoading = false;
    Report_data.addAll(querySnapshot1.docs);
    setState(() {});
  }

  @override
  void initState() {
    getReportData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report page"),
      ),
      body:ListView.builder(
      itemCount: Report_data.length,
      itemBuilder: (context, i) {
        return InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Warning"),
                  content: const Text("are you sure to delete this report?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("cancel")),
                    TextButton(
                        onPressed: () async {
                        await FirebaseFirestore.instance
                              .collection('report')
                              .doc(Report_data[i].id)
                              .delete();
                          Navigator.of(context)
                              .pushReplacementNamed("reportpage");
                        },
                        child: const Text("yes")),
                  ],
                );
              },
            );
          },
          child: ReportCard(
  vehicle_Name: Report_data[i]["vehicle_Name"],
  vehicleType: Report_data[i]["vehicle_Type"],
  created_at: Report_data[i]["created_at"],
  rpm: Report_data[i]["rpm"],
  speed: Report_data[i]["speed"],
  coolantTemp: Report_data[i]["coolantTemp"],
  throttle: Report_data[i]["throttle"],
  voltage: Report_data[i]["voltage"],
  intakeTemp: Report_data[i]["intakeTemp"],
  maf: Report_data[i]["maf"],
  fuelLevel: Report_data[i]["fuelLevel"],
  engineLoad: Report_data[i]["engineLoad"],
  timingAdvance: Report_data[i]["timingAdvance"],
  fuelPressure: Report_data[i]["fuelPressure"],
  intakeManifoldPress: Report_data[i]["intakeManifoldPress"],
  barometricPressure: Report_data[i]["barometricPressure"],
  runTime: Report_data[i]["runTime"],
  distMILOn: Report_data[i]["distMILOn"],
  ambientTemp: Report_data[i]["ambientTemp"],
  dtcCodes: List<String>.from(Report_data[i]["dtcCodes"] ?? []),
  rawData: Report_data[i]["rawData"],
  shortFuel: Report_data[i]["shortFuel"],
  longFuel: Report_data[i]["longFuel"],
  fuelStatus: Report_data[i]["fuelStatus"],
  monitorStatus: Report_data[i]["monitorStatus"],
  distanceSinceClear: Report_data[i]["distanceSinceClear"],
  runTimeSinceClear: Report_data[i]["runTimeSinceClear"],
  fuelRailPressure: Report_data[i]["fuelRailPressure"],
  railPressure: Report_data[i]["railPressure"],
  relativeEngineLoad: Report_data[i]["relativeEngineLoad"],
  actualEngineTorque: Report_data[i]["actualEngineTorque"],
  fuelRate: Report_data[i]["fuelRate"],
)

        );
      },
    ) ,
    );
  
  }
}
