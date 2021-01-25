import 'package:flutter/material.dart';
class AddNeeds extends StatelessWidget{

  TextEditingController _needsController=TextEditingController();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Align(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(
             margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
               child:TextFormField(
                 textAlign: TextAlign.center,
                 controller: _needsController,
                 style: TextStyle(
                     fontSize: 20,
                     textBaseline: TextBaseline.alphabetic
                 ),
                 decoration: InputDecoration(
                   hintText: '描述一下你的需求',
                   hintStyle: TextStyle(
                   ),
                   contentPadding: EdgeInsets.all(8),
                 ),
               ),
           ),
           Container(
             margin: EdgeInsets.only(top: 50,bottom: 40),
             child: FloatingActionButton(
               backgroundColor: Colors.lightBlue,
               child: Icon(Icons.assignment_turned_in_rounded, size: 28,),
               onPressed: () {
                 Navigator.of(context).pop();
               },
             ),
           ),
         ],
       ) ,
     ),

   );
  }
}