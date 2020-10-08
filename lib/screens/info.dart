
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:covid_map/screens/info_detail.dart';
import 'package:intl/intl.dart';


class InfoPage extends StatefulWidget {
  
  @override
  Info createState() => Info();
}

//Info Class 0
class CountryData {
  String name;
  int confirmed;
  int confirmedPrev;
  int recovered;
  int recoveredPrev;
  int deaths;
  int deathsPrev;

  CountryData({
    this.name,
    this.confirmed,
    this.confirmedPrev,
    this.recovered,
    this.recoveredPrev,
    this.deaths,
    this.deathsPrev,
  });

}
//Info Class 1 



class Info extends State<InfoPage> {
  List<String> countries = new List();
  List<CountryData> countriesObject = new List();
  final comaFormat = new NumberFormat("#,###", "en_US");
  int allSumCases = 0;
  int allSumRec = 0;
  int allSumDe = 0;
  int allSumAc = 0;
  int allSumAcPrev = 0;
  int allSumCasesPrev = 0;
  int allSumRecPrev = 0;
  int allSumDePrev = 0;

  var _title = TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white);
  var _smallText = TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Color.fromRGBO(255,177,0,1));
  var _headerNav = TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white);
  var _numbers = TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white);
  var _numbersSub = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white);
  var _notice = TextStyle(fontSize: 6, fontWeight: FontWeight.w800, color: Colors.grey);

  var _infoCases = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color.fromRGBO(255,177,0,1));
  var _infoActive = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color.fromRGBO(79, 147, 255 ,1));
  var _infoRec = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color.fromRGBO(69, 245, 66, 1));
  var _infoDe = TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color.fromRGBO(255, 54, 54,1));

  var isLoading = false;
 
  void initState() {
   
    _fetchData();
    
    super.initState();
  }

  void navigateToDetail(String country) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      if(country == "South Korea"){
        return InfoDetail("Korea, South");
      }else if(country == "United States"){
        return InfoDetail("US");
      }
      return InfoDetail(country);
    }));
  }


  void _fetchData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get("https://pomber.github.io/covid19/timeseries.json");
    
    if (response.statusCode == 200) {
      var data  = json.decode(response.body);

  

      for(var name in data.keys){
        countries.add(name);
        countriesObject.add(CountryData(name: name, confirmed: data[name][data[name].length - 1]['confirmed'], confirmedPrev: data[name][data[name].length - 2]['confirmed'], recovered: data[name][data[name].length - 1]['recovered'], recoveredPrev: data[name][data[name].length - 2]['recovered'], deaths: data[name][data[name].length - 1]['deaths'], deathsPrev: data[name][data[name].length - 2]['deaths']));

      }



      countriesObject.sort((a, b) => b.confirmed.compareTo(a.confirmed));
     
     


  

      for(int i = 0; i < countriesObject.length; i++){
        allSumCases += countriesObject[i].confirmed;
        allSumRec += countriesObject[i].recovered;
        allSumDe += countriesObject[i].deaths;
        allSumCasesPrev += countriesObject[i].confirmedPrev;
        allSumRecPrev += countriesObject[i].recoveredPrev;
        allSumDePrev += countriesObject[i].deathsPrev;
      }
 

      allSumAc = allSumCases - (allSumRec + allSumDe);
      allSumAcPrev = (allSumCases - (allSumRec + allSumDe)) - (allSumCasesPrev - (allSumRecPrev + allSumDePrev));

      var southKorea = countriesObject.where((i) => i.name == "Korea, South").toList();
      southKorea[0].name = "South Korea";

      var unitedStates = countriesObject.where((i) => i.name == "US").toList();
      unitedStates[0].name = "United States";   

      var unitedStatesString = countries.where((i) => i == "US").toList();
      countries.remove(unitedStatesString[0]);
      unitedStatesString[0] = "United States";
      countries.add(unitedStatesString[0]);


      var southKoreaString = countries.where((i) => i == "Korea, South").toList();
      countries.remove(southKoreaString[0]);
      southKoreaString[0] = "South Korea";
      countries.add(southKoreaString[0]);

  

      setState(() {
        isLoading = false;
      });

      print("Database connected!");
    } 
    else {
      throw Exception('Failed to load photos');
    }
  

  }


  void _inScreenFetchData() async {
    countriesObject.clear();
    _fetchData();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
          child: Card(
            color: Colors.green,
                 shape: RoundedRectangleBorder(
                
                  borderRadius: BorderRadius.circular(12.0),
                ),
              child: IconButton(icon: Icon(Icons.search), onPressed: () {
                showSearch(context: context, delegate: DataSearch(this.countries));
              },)
             )
          )

        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : Stack(
        children: <Widget>[
          CustomScrollView(
            
            slivers: <Widget>[
    
              SliverAppBar(
                expandedHeight: 370.0,
                backgroundColor: Color.fromRGBO(26,34,40,1),
           
                flexibleSpace:  FlexibleSpaceBar(
                  background: Container(
                    
                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                          child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Card(
                            color: Colors.black,
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.1),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                            padding: EdgeInsets.all(15),
                              child: ListTile(
                                leading: CircleAvatar(
                                      backgroundImage: AssetImage('assets/world.jpg'),
                                      radius: 30,
                                      
                                    ),

                                title: Text("All Countries", style: _headerNav,),
                                subtitle: Text("Source (pomber.github.io/covid19/timeseries.json)", style: _notice,),

                              )
                            )
                            
                          ),
                        ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Card(
                                    color: Colors.black,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                    padding: EdgeInsets.all(20.0),
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
                                                  width: 120,
                                                  
                                      
                                                  child: Text('${comaFormat.format(allSumCases)}', style: _numbers, textAlign: TextAlign.left,),
                                                ),
                                          
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                             Row(
                                              children: <Widget>[
                                            
                        
                                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                                                Container(
                                                  width: 130,
                                                    
                                                  child: Text('+${comaFormat.format(allSumCases - allSumCasesPrev)}', style: _numbersSub, textAlign: TextAlign.center,),
                                                  
                                                ),
                                                
                                          
                                              ],
                                            ),


                                        ],
                                      )
                                    )
                                    
                                  ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Card(
                                    color: Colors.black,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                        Container(
                                            width: 180,
                                            child: Text("Total Active", style: _infoActive,),
                                          ),
                                          Padding(padding: EdgeInsets.all(5)),
                                          Row(
                                              children: <Widget>[
                                                Icon(Icons.timelapse, color: Color.fromRGBO(79, 147, 255 ,1), size: 20,),
                                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                                                Container(
                                                  width: 120,
                                               
                                            
                                                  child: Text('${comaFormat.format(allSumAc)}', style: _numbers, textAlign: TextAlign.left,),
                                                ),
                                          
                                              ],
                                            ),

                                           Padding(padding: EdgeInsets.all(5)),
                                             Row(
                                              children: <Widget>[
                                            
                        
                                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                                                Container(
                                                  width: 130,
                                             
                                                                                  
                                                  child: Text('+${comaFormat.format(allSumAcPrev)}', style: _numbersSub, textAlign: TextAlign.center,),
                                                  
                                                ),
                                                
                                          
                                              ],
                                            ),
                                          
                                        ],
                                      )
                                    )
                                    
                                  ),
                              ),
                            ]
                          ),

                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Card(
                                    color: Colors.black,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                    padding: EdgeInsets.all(20.0),
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
                                                  width: 120,
                                            
                                                  child: Text('${comaFormat.format(allSumRec)}', style: _numbers, textAlign: TextAlign.left,),
                                                ),
                                          
                                              ],
                                            ),
                                          Padding(padding: EdgeInsets.all(5)),
                                             Row(
                                              children: <Widget>[
                                            
                        
                                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                                                Container(
                                                  width: 130,
                                             
                                                                                  
                                                  child: Text('+${comaFormat.format(allSumRec - allSumRecPrev)}', style: _numbersSub, textAlign: TextAlign.center,),
                                                  
                                                ),
                                                
                                          
                                              ],
                                            ),
                                        ],
                                      )
                                    )
                                    
                                  ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Card(
                                    color: Colors.black,
                                    elevation: 1.0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: Padding(
                                    padding: EdgeInsets.all(20.0),
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
                                                  width: 120,
                  
                                                                                  
                                                  child: Text('${comaFormat.format(allSumDe)}', style: _numbers, textAlign: TextAlign.left,),
                                                  
                                                ),
                                                
                                          
                                              ],
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                             Row(
                                              children: <Widget>[
                                            
                        
                                                Padding(padding: EdgeInsets.fromLTRB(0, 0, 8, 0)),
                                                Container(
                                                  width: 130,
                                             
                                                                                  
                                                  child: Text('+${comaFormat.format(allSumDe - allSumDePrev)}', style: _numbersSub, textAlign: TextAlign.center,),
                                                  
                                                ),
                                                
                                          
                                              ],
                                            ),
                                        ],
                                      )
                                    )
                                    
                                  ),
                              ),
                            ]
                          ),

                        )

     

                //     [30, 50, 20] = 100 - 40 = 60

                //                     80 - 30 = 50

                //     [10, 20, 10] = 40 - 10 = 10
                //     20 - 10



                //     [20] = 20
                //     [10] = 10
                    

                // CC (100 - 40) - (80 - 30) =
                //   60 - 50 = 10
                // CAC 60

                
                      ]
                              
                    ),
   
                  )
                
       
                ),
                
              ),
              
              SliverList(
                
                delegate: SliverChildBuilderDelegate((context, index) {
 
                    return Container(
                    
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Card(
                        color: Colors.black,
                        elevation: 1.0,
                      
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        
                      child: Padding(
                            padding: EdgeInsets.all(16.0),
                          child: ListTile(

                      

                          leading: FittedBox(
                            fit: BoxFit.fill,
                            child: Row(
                              
                              children: <Widget>[
                              
                                Text((index + 1).toString(), style: _title,),
                                  Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),),
                                    CircleAvatar(
                                      backgroundImage: NetworkImage( 'https://www.sciencekids.co.nz/images/pictures/flags680/'+ countriesObject[index].name.replaceAll(" ", "_").replaceAll('*', '').toString() +'.jpg'),
                                      radius: 22,
                                    ),
                              ],
                            )
                            ),
                          
                        

                            title:  Text(countriesObject[index].name.toString(), style: _title,), 
                          

                          
                            trailing: FittedBox(
                              fit: BoxFit.fill,
                              child: Column(
                                children: <Widget>[
                                  Text('${comaFormat.format(countriesObject[index].confirmed)}', style: _title,), 
                                  Text('Confirmed cases', style: _smallText,), 

                                ],
                              )

                            ),

                            
                            
                            

                            onLongPress: () {
                
                        

                            },

                
                      
                            
                            onTap: () {
                              navigateToDetail(countriesObject[index].name);
                              
                            },
                          ),
                      )
                      ),




                    );
                  },
                  childCount: countriesObject.length,
                )
              )
   

            ],
            
          ),


        ],
      )
      
 
    );
  }

}

class DataSearch extends SearchDelegate<String>{
  var _title = TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white);
  List<String> countries;
  DataSearch(this.countries);
  




  List countries2 = ["United States", "Canada", "Spain", "Italy", "Germany"]; 

  


  @override
  ThemeData appBarTheme(BuildContext context) {
      return Theme.of(context);
      
  }
    
  void navigateToDetail(String country, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if(country == "South Korea"){
        return InfoDetail("Korea, South");
      }else if(country == "United States"){
        return InfoDetail("US");
      }
      return InfoDetail(country);
    }));
  }



  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, 
          progress: transitionAnimation,
          ), 
        onPressed: (){
          close(context, null);
          // print(countries);
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty 
    ? countries2 
    : countries.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();



    
      return ListView.builder(
        
        itemCount: suggestionList.length,
        itemBuilder: (BuildContext context, int index) {
        return Container(
  
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Card(
                color: Colors.black,
                elevation: 1.0,
              
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                
              child: Padding(
                    padding: EdgeInsets.all(16.0),
                  child: ListTile(



               

                  leading: CircleAvatar(
                              backgroundImage: NetworkImage( 'https://www.sciencekids.co.nz/images/pictures/flags680/'+ suggestionList[index].replaceAll(" ", "_").replaceAll('*', '').toString() +'.jpg'),
                              radius: 22,
                            ),





                    title:  RichText(text: TextSpan( 
                      text: suggestionList[index].substring(0, query.length),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      children: [TextSpan(
                          text: suggestionList[index].substring(query.length),
                          style: TextStyle(color: Colors.grey),
                        )]
                      ),),
                      
                    onLongPress: () {
         
                

                    },

        
              
                    
                    onTap: () {
                      navigateToDetail(suggestionList[index], context);
                    },
                  ),
              )
              ),




            );

        }


    );
  }
  
}

