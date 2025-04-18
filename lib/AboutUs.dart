import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(("About Us"),
            style: TextStyle(
              fontSize: 30,
            )),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("this application are done by our team:",style: TextStyle(fontSize: 20)),
          ),
         Container(decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25), 
            color: Colors.grey[200] ,
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(left: 20,top: 20,right: 500),
          height: 200,
          width: 100,child: Text("Team members:\nAmjad Alinzi\nkhalid Alharbi\nabdulmalek kutbi",style: TextStyle(fontSize: 20),),
          
 
          )
        ],
      ),
    );
  }
}
