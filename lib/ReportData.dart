import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportData extends StatelessWidget {
  final String vehicle_Name;
  final String vehicleType;
  final Timestamp created_at;
  final String rpm;
  final String speed;
  final String coolantTemp;
  final String throttle;
  final String voltage;
  final String intakeTemp;
  final String maf;
  final String fuelLevel;
  final String engineLoad;
  final String timingAdvance;
  final String fuelPressure;
  final String intakeManifoldPress;
  final String barometricPressure;
  final String runTime;
  final String distMILOn;
  final String ambientTemp;
  final List<String> dtcCodes;
  final String rawData;
  final String shortFuel;
  final String longFuel;
  final String fuelStatus;
  final String monitorStatus;
  final String distanceSinceClear;
  final String runTimeSinceClear;
  final String fuelRailPressure;
  final String railPressure;
  final String relativeEngineLoad;
  final String actualEngineTorque;
  final String fuelRate;

  const ReportData({
    super.key,
    required this.vehicle_Name,
    required this.vehicleType,
    required this.created_at,
    required this.rpm,
    required this.speed,
    required this.coolantTemp,
    required this.throttle,
    required this.voltage,
    required this.intakeTemp,
    required this.maf,
    required this.fuelLevel,
    required this.engineLoad,
    required this.timingAdvance,
    required this.fuelPressure,
    required this.intakeManifoldPress,
    required this.barometricPressure,
    required this.runTime,
    required this.distMILOn,
    required this.ambientTemp,
    required this.dtcCodes,
    required this.rawData,
    required this.shortFuel,
    required this.longFuel,
    required this.fuelStatus,
    required this.monitorStatus,
    required this.distanceSinceClear,
    required this.runTimeSinceClear,
    required this.fuelRailPressure,
    required this.railPressure,
    required this.relativeEngineLoad,
    required this.actualEngineTorque,
    required this.fuelRate,
  });

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = created_at.toDate();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Report'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle("Vehicle Information"),
            buildItem("Vehicle Name", vehicle_Name),
            buildItem("Vehicle Type", vehicleType),
            buildItem("Created At", date.toString()),

            const Divider(),
            buildSectionTitle("Sensor Data"),
            buildItem("Speed", "$speed km/h"),
            buildItem("RPM", rpm),
            buildItem("Coolant Temp", "$coolantTemp °C"),
            buildItem("Throttle Position", "$throttle%"),
            buildItem("Voltage", "$voltage V"),
            buildItem("Intake Temp", "$intakeTemp °C"),
            buildItem("MAF", "$maf g/s"),
            buildItem("Ambient Temp", "$ambientTemp °C"),

            const Divider(),
            buildSectionTitle("Fuel & Engine Data"),
            buildItem("Fuel Level", "$fuelLevel%"),
            buildItem("Engine Load", "$engineLoad%"),
            buildItem("Timing Advance", timingAdvance),
            buildItem("Fuel Pressure", "$fuelPressure kPa"),
            buildItem("Intake Manifold Pressure", intakeManifoldPress),
            buildItem("Barometric Pressure", barometricPressure),
            buildItem("Fuel Status", fuelStatus),
            buildItem("Fuel Rail Pressure", fuelRailPressure),
            buildItem("Rail Pressure", railPressure),
            buildItem("Relative Engine Load", relativeEngineLoad),
            buildItem("Actual Engine Torque", actualEngineTorque),
            buildItem("Fuel Rate", "$fuelRate L/h"),

            const Divider(),
            buildSectionTitle("Operation Info"),
            buildItem("Run Time", "$runTime min"),
            buildItem("Distance With MIL On", "$distMILOn km"),
            buildItem("Distance Since Clear", distanceSinceClear),
            buildItem("Run Time Since Clear", "$runTimeSinceClear min"),

            const Divider(),
            buildSectionTitle("Fuel Trim Data"),
            buildItem("Short Fuel Trim", shortFuel),
            buildItem("Long Fuel Trim", longFuel),

            const Divider(),
            buildSectionTitle("Monitoring & Codes"),
            buildItem("Monitor Status", monitorStatus),
            buildItem("Raw Data", rawData),
            buildItem("DTC Codes", dtcCodes.isEmpty ? "None" : dtcCodes.join(", ")),
          ],
        ),
      ),
    );
  }
}
