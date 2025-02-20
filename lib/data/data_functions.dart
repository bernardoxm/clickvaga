import 'package:clickvagas/data/data_base.dart';
import 'package:sqflite/sqflite.dart';

class DataFunctions {
final DatabaseHelper dbHelper = DatabaseHelper();


// nao colocar regra de negocio aqui
Future<int> insertData(String table, Map<String, dynamic> data) async {
  final Database db = await dbHelper.database;
  return db.insert(table, data); 

 

}



}