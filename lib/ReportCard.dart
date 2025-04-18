import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ReportData.dart';
import 'package:intl/intl.dart';



class ReportCard extends StatelessWidget {
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
  final String ambientTemp; // Ambient Air Temperature
  final List<String> dtcCodes; // DTC codes list
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

  const ReportCard(
      // ignore: non_constant_identifier_names
      {super.key, required this.vehicle_Name, required this.vehicleType, required this.created_at, required this.rpm, required this.speed, required this.coolantTemp, required this.throttle, required this.voltage, required this.intakeTemp, required this.maf, required this.fuelLevel, required this.engineLoad, required this.timingAdvance, required this.fuelPressure, required this.intakeManifoldPress, required this.barometricPressure, required this.runTime, required this.distMILOn, required this.ambientTemp, required this.dtcCodes, required this.rawData, required this.shortFuel, required this.longFuel, required this.fuelStatus, required this.monitorStatus, required this.distanceSinceClear, required this.runTimeSinceClear, required this.fuelRailPressure, required this.railPressure, required this.relativeEngineLoad, required this.actualEngineTorque, required this.fuelRate,
     
     });

       String getVehicleImage() {
    switch (vehicleType.toLowerCase()) {
      case 'car':
        return "images/sport-car.png";
      case 'truck':
        return "images/truck.png"; // Make sure you have this image asset
      case 'heavy equipment':
        return "images/construction.png"; // Make sure you have this image asset
      default:
        return "images/sport-car.png"; // Default image
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      
        color: Colors.white,
        margin: const EdgeInsets.all(15),
        child: InkWell (
         onTap: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
             ReportData(vehicle_Name: vehicle_Name, vehicleType: vehicleType, created_at: created_at, 
             rpm: rpm, speed: speed, coolantTemp: coolantTemp, throttle: throttle, voltage: voltage,
              intakeTemp: intakeTemp, maf: maf, fuelLevel: fuelLevel, engineLoad: engineLoad,
               timingAdvance: timingAdvance, fuelPressure: fuelPressure, intakeManifoldPress: intakeManifoldPress,
                barometricPressure: barometricPressure, runTime: runTime, distMILOn: distMILOn, ambientTemp: ambientTemp, 
                dtcCodes: dtcCodes, rawData: rawData, shortFuel: shortFuel, longFuel: longFuel, fuelStatus: fuelStatus,
                 monitorStatus: monitorStatus, distanceSinceClear: distanceSinceClear, runTimeSinceClear: runTimeSinceClear, 
                 fuelRailPressure: fuelRailPressure, railPressure: railPressure, relativeEngineLoad: relativeEngineLoad, 
                 actualEngineTorque: actualEngineTorque, fuelRate: fuelRate)));
                  },
          child:Container(
          height: 100,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(

                children: [
                  SizedBox(
                    
                    height: 60,
                    width: 75,
                    child:
                     Image.asset(
                      getVehicleImage(),
                      height: 40,
                      width: 40,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                        subtitle: Text(vehicleType),
                        title: Text(vehicle_Name , style: TextStyle(fontWeight: FontWeight.bold),),
                       trailing: Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(created_at.toDate()),),
                        ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: Icon(Icons.arrow_right
                  )
                 
                ),
              )
            ],
          ),
        )));
  }
}
