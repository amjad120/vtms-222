import 'package:flutter/material.dart';
import 'package:flutter_application_1/action/UpdateVehicle.dart';


class Vehiclecard extends StatelessWidget {
  final String vehicleName;
  final String docid;
  final String chassisNumber;
  final String plateNumber;
  final String color;
  final String vehicleType;
  final String coverdDistance;

  const Vehiclecard(
      {super.key,
      required this.docid,
      required this.vehicleName,
      required this.chassisNumber,
      required this.plateNumber,
      required this.color,
      required this.vehicleType,
      required this.coverdDistance, 
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
        Updatevehicle(docid: docid, oldvehicleName: vehicleName, oldchassisNumber: chassisNumber, 
        oldplateNumber: plateNumber, oldcolor: color, oldvehicleType: vehicleType,
         oldcoverdDistance: coverdDistance)));
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
                        title: Text(vehicleName , style: TextStyle(fontWeight: FontWeight.bold),),
                        trailing: Text(plateNumber)
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
