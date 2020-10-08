import 'package:flutter/material.dart';
import 'package:covid_map/models/stat_item.dart';




class DataDetail extends StatefulWidget {

  final StatItem item;

  DataDetail(this.item);


  State<StatefulWidget> createState(){
    return DataDetailScreen(this.item);
  }
  

}



class DataDetailScreen extends State<DataDetail> {
  final StatItem item;

  DataDetailScreen(this.item);
  
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text(item.country),
      ),
      
      body: Center(
        child: RaisedButton(
          child: Text(item.description),
          onPressed: () {
         
          },
        ),
      ),
    );
  }

}