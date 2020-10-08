import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';



class InfoDetail extends StatefulWidget {

   String country;

  InfoDetail(this.country);


  State<StatefulWidget> createState(){
    return InfoDetailScreen(this.country);
  }
  

}

//Info Class 0
class CountryData {
  String date;
  int confirmed;
  int deaths;
  int recovered;

  CountryData({
    this.date,
    this.confirmed,
    this.deaths,
    this.recovered,
  });


  factory CountryData.fromJson(Map<String, dynamic> json){
    return  CountryData(
      date: json["date"],
      confirmed: json["confirmed"],
      deaths: json["deaths"],
      recovered: json["recovered"],
  
    );
  }
}
//Info Class 1 


class InfoDetailScreen extends State<InfoDetail> {
  String country;
  InfoDetailScreen(this.country);
  final comaFormat = new NumberFormat("#,###", "en_US");
  

  //Styling Start 
  var _title = TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white);
  var _subtitle = TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white);
  var _numbers = TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white);
  var _numbersSub = TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white);

  var _infoCases = TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color.fromRGBO(255,177,0,1));
  var _infoActive = TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color.fromRGBO(79, 147, 255 ,1));
  var _infoRec = TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color.fromRGBO(69, 245, 66, 1));
  var _infoDe = TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color.fromRGBO(255, 54, 54,1));
  var _chartsTitle = TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white);
  var _chartsText = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white);


  double activeCases;
  double closedCasesPercent;

  double closedCasesTot;
  double recoveredPercent;
  double deathsPercent;



  var recoveries;
  var deaths;

  List<PieChartSectionData> _sections = List<PieChartSectionData>();
  List<PieChartSectionData> _sectionCases = List<PieChartSectionData>();




  //Styling End

  var isLoading = false;

  List countryData = new List();

  void initState() {
    _fetchData();
    super.initState();
  }
 

  void _fetchData() async {

    setState(() {
      isLoading = true;
    });

    final response = await http.get("https://pomber.github.io/covid19/timeseries.json");

    
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      countryData = (data[country.toString()] as List)
        .map<CountryData>((json) => CountryData.fromJson(json)).toList();


      activeCases = ((countryData.last.confirmed - countryData.last.recovered - countryData.last.deaths + 0.0)/countryData.last.confirmed) * 100;
      closedCasesPercent = 100 - activeCases + 0.0;

      print(closedCasesPercent);
    
      closedCasesTot = (countryData.last.recovered + countryData.last.deaths + 0.0001);

      recoveredPercent = ((countryData.last.recovered / closedCasesTot) * 100);

      deathsPercent = ((countryData.last.deaths / closedCasesTot) * 100);

      PieChartSectionData _item1 = PieChartSectionData(
        color: Color.fromRGBO(46, 184, 46, 1), 
        value: recoveredPercent,
        radius: 30, 
        title: recoveredPercent.toStringAsFixed(0) + "%" ,
        titleStyle: _chartsText
      );

      PieChartSectionData _item2 = PieChartSectionData(
        color: Color.fromRGBO(204, 0, 0,1), 
        value: deathsPercent,
        title: deathsPercent.toStringAsFixed(0) + "%",
        radius: 30, 
        titleStyle: _chartsText
      );

      _sections = [_item1, _item2];


      PieChartSectionData _active = PieChartSectionData(
        color: Color.fromRGBO(79, 147, 255 ,1), 
        value: activeCases,
        radius: 30, 
        title: activeCases.toStringAsFixed(0) + "%" ,
        titleStyle: _chartsText
      );

      PieChartSectionData _closed = PieChartSectionData(
        color: Color.fromRGBO(255,177,0,1), 
        value: closedCasesPercent,
        title: closedCasesPercent.toStringAsFixed(0) + "%",
        radius: 30, 
        titleStyle: _chartsText
      );

      _sectionCases = [_active, _closed];



        
      setState(() {
        isLoading = false;
      });

      print("Database connected!");
    } 
    else {
      throw Exception('Failed to load photos');
    }
  }





  Widget countryTile(){
    if(country == "Korea, South"){
      country = "South Korea";
    }else if(country == "US"){
      country = "United States";
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.black,
      child: Padding(
        padding:  EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Image.network(
                'https://www.sciencekids.co.nz/images/pictures/flags680/'+ country.replaceAll(" ", "_").replaceAll('*', '').toString() +'.jpg',
                width: 100,

                fit: BoxFit.fill,
              ), 
            ),
            Padding(padding: EdgeInsets.all(12)),
            Text(country, style: _title,),

          ],
        ),
      )
    );
  }


  Widget activeTile(){
    int activeCases = (countryData.last.confirmed)-(countryData.last.recovered + countryData.last.deaths);
    int activeCasesPrev = (countryData[countryData.length - 2 ].confirmed)-(countryData[countryData.length - 2 ].recovered + countryData[countryData.length - 2 ].deaths);
    int activeCasesDiff = (activeCases)-(activeCasesPrev);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Expanded(
          flex: 6, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: Text("Total Active Cases", style: _infoActive,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: <Widget>[
                       
                          Icon(Icons.timelapse, color: Color.fromRGBO(79, 147, 255 ,1), size: 20,),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                          Container(
                            width: 160,
                      
                            child: Text('${comaFormat.format(activeCases)}', style: _numbers, textAlign: TextAlign.left,),
                          ),
                    
                        ],
                      ),
           
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      Expanded(
          flex: 4, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 22),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 109,
                        child: Text("Daily Increase", style: _infoActive,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        width: 109,
                      
                        child: Text(
                            (() {
                                if(activeCasesDiff > 0){
                                  return '+${comaFormat.format(activeCasesDiff)}';}

                                  return '${comaFormat.format(activeCasesDiff)}';
                              })()
                          
                              ,style: _numbersSub, textAlign: TextAlign.left,
                          
                          ),
                      ),

                    ]
                  ),
                )
              ],

            )
          ),
        ),
        ],
      );

  }


  Widget confirmedTile(){
    int diffCases = (countryData.last.confirmed)-(countryData[countryData.length - 2].confirmed);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Expanded(
          flex: 6, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: Text("Total Confirmed Cases", style: _infoCases,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: <Widget>[
                       
                          Icon(Icons.check, color: Color.fromRGBO(255,177,0,1), size: 20,),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                          Container(
                            width: 160,
                      
                            child: Text('${comaFormat.format(countryData.last.confirmed)}', style: _numbers, textAlign: TextAlign.left,),
                          ),
                    
                        ],
                      ),
           
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      Expanded(
          flex: 4, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 22),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 109,
                        child: Text("Daily Increase", style: _infoCases,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        width: 109,
                      
                        child: Text(
                            (() {
                                if(diffCases > 0){
                                  return '+${comaFormat.format(diffCases)}';}

                                  return '${comaFormat.format(diffCases)}';
                              })()
                          
                              ,style: _numbersSub, textAlign: TextAlign.left,
                          
                          ),
                      ),

                    ]
                  ),
                )
              ],

            )
          ),
        ),
        ],
      );

  }




  Widget recoveredTile(){
    int diffRecovered = (countryData.last.recovered)-(countryData[countryData.length - 2].recovered);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Expanded(
          flex: 6, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: Text("Total Recovered", style: _infoRec,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: <Widget>[
                       
                          Icon(Icons.favorite, color: Color.fromRGBO(69, 245, 66, 1), size: 20,),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                          Container(
                            width: 160,
                      
                            child: Text('${comaFormat.format(countryData.last.recovered)}', style: _numbers, textAlign: TextAlign.left,),
                          ),
                    
                        ],
                      ),
           
                    ],
                  ),
                )
              ],
            )
          ),
        ),
       Expanded(
          flex: 4, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 22),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 109,
                        child: Text("Daily Increase", style: _infoRec,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        width: 109,
                      
                        child: Text(
                            (() {
                                if(diffRecovered > 0){
                                  return '+${comaFormat.format(diffRecovered)}';}

                                  return '${comaFormat.format(diffRecovered)}';
                              })()
                          
                              ,style: _numbersSub, textAlign: TextAlign.left,
                          
                          ),
                      ),

                    ]
                  ),
                )
              ],

            )
          ),
        ),
        ],
      );
  }


  Widget deathsTile(){
    int diffDeaths = (countryData.last.deaths)-(countryData[countryData.length - 2].deaths);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Expanded(
          flex: 6, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 180,
                        child: Text("Total Deaths", style: _infoDe,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Row(
                        children: <Widget>[
                    
                          Image.asset(
                            'assets/angel.png',
                            height: 20,
                            width: 20,
                          ),
                          
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                          Container(
                            width: 160,
                 
                            child: Text('${comaFormat.format(countryData.last.deaths)}', style: _numbers, textAlign: TextAlign.left,),
                          ),
                    
                        ],
                      ),
           
                    ],
                  ),
                )
              ],
            )
          ),
        ),
        Expanded(
          flex: 4, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 22),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 109,
                        child: Text("Daily Increase", style: _infoDe,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        width: 109,
                      
                        child: Text(
                            (() {
                                if(diffDeaths > 0){
                                  return '+${comaFormat.format(diffDeaths)}';}

                                  return '${comaFormat.format(diffDeaths)}';
                              })()
                          
                              ,style: _numbersSub, textAlign: TextAlign.left,
                          
                          ),
                      ),

                    ]
                  ),
                )
              ],

            )
          ),
        ),
        ],
      );
  }

  Widget infoTile(){
    int diffCases = (countryData.last.confirmed)-(countryData[countryData.length - 2].confirmed);
    int diffRecovered = (countryData.last.recovered)-(countryData[countryData.length - 2].recovered);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.black,
      
      child: Padding(
        padding:  EdgeInsets.all(20),

        child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
       
          children: <Widget>[
            Column(
              children: <Widget>[
                 Text("Differece Cases", style: _infoCases,),
                 Padding(padding: EdgeInsets.all(5),),
                 Text('+${comaFormat.format(diffCases)}', style: _numbers,),
              ],
            ),
            Column(
              children: <Widget>[
           
                 Text("Differece Recovered", style: _infoRec,),
                 Padding(padding: EdgeInsets.all(5),),
                 Text('+${comaFormat.format(diffRecovered)}', style: _numbers,),
              ],
              
            ),




                ],
          ),
        )

    );

  }

  

  Widget chartTile(){
    int diffDeaths = (countryData.last.deaths)-(countryData[countryData.length - 2].deaths);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
        Expanded(
          flex: 5, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 145,
                     
                        child: Text("Cases Overview", style: _chartsTitle,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        width: 145,
                        height: 150,
                        child: AspectRatio(
                          aspectRatio: 1,            
                          child: FlChart(
                            chart: PieChart(
                              PieChartData(
                                sections: _sectionCases, 
                                borderData: FlBorderData(show: false),
                                centerSpaceRadius: 30,
                                sectionsSpace: 0, 
                              )
                            )
                          ),
                        ),
                      ),
                      Container(
                        width: 145,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lens, color: Color.fromRGBO(255,177,0,1), size: 15,),
                            Padding(padding: EdgeInsets.fromLTRB(2, 0, 0, 0)),
                            Text("Closed", style: _chartsTitle,),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            Icon(Icons.lens, color: Color.fromRGBO(79, 147, 255 ,1), size: 15,),
                            Padding(padding: EdgeInsets.fromLTRB(2, 0, 0, 0)),
                            
                            Text("Active", style: _chartsTitle,),
                          ],
                        ),

                      )

           
                    ],
                  ),
                )
              ],
            )
          ),
        ),
        Expanded(
          flex: 5, // 20%
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 22, 20, 22),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 145,
                    
                        child: Text("Closed Cases Overview", style: _chartsTitle,),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Container(
                        width: 145,
                        height: 150,
                        child: AspectRatio(
                          aspectRatio: 1,            
                          child: FlChart(
                            chart: PieChart(
                              PieChartData(
                                sections: _sections, 
                                borderData: FlBorderData(show: false),
                                centerSpaceRadius: 30,
                                sectionsSpace: 0, 
                              )
                            )
                          ),
                        ),
                      ),
                      Container(
                        width: 145,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.lens, color: Color.fromRGBO(46, 184, 46, 1), size: 15,),
                            Padding(padding: EdgeInsets.fromLTRB(2, 0, 0, 0)),
                            Text("Recovered", style: _chartsTitle,),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            Icon(Icons.lens, color: Color.fromRGBO(204, 0, 0,1), size: 15,),
                            Padding(padding: EdgeInsets.fromLTRB(2, 0, 0, 0)),
                            
                            Text("Deaths", style: _chartsTitle,),
                          ],
                        ),

                      )
                    ]
                  ),
                )
              ],

            )
          ),
        ),
        ],
      );
  }



  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.black,
      ),
      
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        
        child: isLoading ? Center(
              child: CircularProgressIndicator(),
          ) : ListView(
      
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                countryTile(),
                Padding(padding: EdgeInsets.all(5)),
                confirmedTile(),
                Padding(padding: EdgeInsets.all(5)),
                activeTile(),
                Padding(padding: EdgeInsets.all(5)),
                recoveredTile(),
                Padding(padding: EdgeInsets.all(5)),
                deathsTile(),
                Padding(padding: EdgeInsets.all(5)),
                chartTile(),
                Padding(padding: EdgeInsets.all(5)),
         
         
                // infoTile()
          

              ],
            

        ), 
        

      ),
    );
  }
}
