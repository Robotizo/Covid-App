import 'package:flutter/material.dart';
import 'package:covid_map/screens/data.dart';
import 'package:covid_map/screens/map.dart';
import 'package:covid_map/screens/info.dart';
import 'package:covid_map/services/db.dart';
import 'package:covid_map/screens/settings.dart';


void main() async {

    WidgetsFlutterBinding.ensureInitialized();

    await DB.init();

    runApp(MyApp());

    
}



class MyApp extends StatefulWidget {
  @override
  MyAppScreen createState() => MyAppScreen();
}


class MyAppScreen extends State<MyApp> {
var _menu = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

    
  int _selectedIndex = 0;
  final _pageOptions = [
    InfoPage(),
    SettingsPage(),
  ];



    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map App',      
      home: Scaffold(
      
        body: _pageOptions[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(26,34,40,1), 
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items:  <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.equalizer, color: Colors.white,),
              title: Text('Statistics', style: _menu,),
              activeIcon: Icon(Icons.equalizer, color: Colors.blue,), 
            ),


            BottomNavigationBarItem(
              icon: Icon(Icons.map, color: Colors.white,),
              title: Text('Settings', style: _menu,),
              activeIcon: Icon(Icons.map, color: Colors.blue,), 
            ),
  



          ],
        )


      ),

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color.fromRGBO(26,34,40,1),
      ),

      
    );
  }
}


