
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:covid_map/models/model.dart';




abstract class DB {

    static Database _db;

    static int get _version => 3;


    static Future<void> init() async {

        if (_db != null) { return; }

        try {
            String _path = await getDatabasesPath() + 'example';
            _db = await openDatabase(_path, version: _version, onCreate: onCreate, onUpgrade: _onUpgrade);
        }
        catch(ex) { 
            print(ex);
        }
    }

    static void onCreate(Database db, int version) async =>
        await db.execute('CREATE TABLE stat_items (id INTEGER PRIMARY KEY NOT NULL, country STRING)');

    static void _onUpgrade(Database db, int oldVersion, int newVersion) async {
      if(newVersion > oldVersion){
        await db.execute("ALTER TABLE stat_items ADD COLUMN description STRING;");
      }
    }
  
    static Future<List<Map<String, dynamic>>> query(String table) async => _db.query(table);

    static Future<int> insert(String table, Model model) async =>
        await _db.insert(table, model.toMap());
    
    static Future<int> update(String table, Model model) async =>
        await _db.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

    static Future<int> delete(String table, Model model) async =>
        await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}