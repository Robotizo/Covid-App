import 'package:flutter/material.dart';
import 'package:covid_map/models/stat_item.dart';
import 'package:covid_map/services/db.dart';
import 'package:covid_map/screens/data_detail.dart';
import 'package:covid_map/screens/info.dart';

class DataPage extends StatefulWidget {

  DataPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Data createState() => Data();
}

class Data extends State<DataPage> {


  String _country;
  String _description;

  List<StatItem> countries = [];

 TextStyle _style = TextStyle(color: Colors.black, fontSize: 18);


  List<Widget> get _items => countries.map((item) => format(item)).toList();



  void navigateToDetail(StatItem country) {
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return DataDetail(country);
    }));
  }
 

  void initState() {
    refresh();
    super.initState();
  }


  void _delete(StatItem item) async {  
    DB.delete(StatItem.table, item);
    refresh();
  }


  void _save() async {
    Navigator.of(context).pop();
    StatItem item = StatItem(
        country: _country,
        description: _description,
    );
    await DB.insert(StatItem.table, item);
    setState(() => _country = '' );
    setState(() => _description = '' );
    refresh();
  }

  void _create(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Country"),
            actions: <Widget>[
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop()
                ),
                FlatButton(
                    child: Text('Save'),
                    onPressed: () => _save()
                )

            ],
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                    TextField(
                              autofocus: true,
                              decoration: InputDecoration(labelText: 'Country Name'),
                              onChanged: (value) { _country = value; },
                          ),
                          TextField(
                              autofocus: true,
                              decoration: InputDecoration(labelText: 'Country Description'),
                              onChanged: (value) { _description = value; },
                          ),


                ],
              ),
            )
            
            
            
     
            
        );
      }
    );
  }


  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(StatItem.table);
    countries = _results.map((item) => StatItem.fromMap(item)).toList();
    setState(() { });
  }

  void returnItems() {
    for (var name in countries) {
        print(name.country);
      }
    print(countries.length);
  }



  Widget format(StatItem item) {

    return Dismissible(
        key: Key(item.id.toString()),

        child: Container(
          padding: EdgeInsets.only(top: 5, left: 5, right: 5),
        
            child: Card(
                  child: ListTile(
                    title: Text(item.country.toString(), style: _style,),
                    subtitle: Text(item.description.toString(), style: _style,),
                    
                    onLongPress:() {
                      print("Test");
                    },
                    onTap: (){
                       navigateToDetail(item);
                    },
                    
                ),
        
            )
            
        ),

        onDismissed: (DismissDirection direction) => _delete(item),
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
   
      body: Padding(
        padding: EdgeInsets.only(top: 25, left: 0, right: 0),
        child: ListView( 
  
          children: _items
        )
      ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
             mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
        
                FloatingActionButton(
                  
                  heroTag: "btn1",
                  onPressed: () { _create(context); },
                  tooltip: 'New TODO',
                  child: Icon(Icons.library_add),
                ),
                

              ],
            ),




          )



      ),
    );
  }
}