import 'package:clickvagas/data/data_base.dart';
import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/models/spot_card_info.dart';
import 'package:clickvagas/models/spot_model.dart';
import 'package:sqflite/sqflite.dart';

class DataFunctions {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> insertSpots(List<SpotModel> spots) async {
    final Database db = await dbHelper.database;
    await db.transaction((txn) async {
      for (final spot in spots) {
        await txn.insert(
          'spot',
          spot.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    });
    
  }

Future<List<SpotModel>> getSpots() async {
  final Database db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('spot');

  return maps.map((map) {
    return SpotModel(
      id: map['id'].toString(),
      name: map['name'],
      isOccupied: (map['isOccupied'] == 1 ? true : false), 
      
    );
  }).toList();
  
}

  Future<void> insertANewSpot(SpotModel spot) async {
    final Database db = await dbHelper.database;
    await db.insert(
      'spot',
      spot.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteSpot(String id) async {
    final Database db = await dbHelper.database;
    await db.delete(
      'spot',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
Future<void> insertPlateWithSpot(ParkingSpotModel parkingSpot) async {
  final Database db = await dbHelper.database;


  if (parkingSpot.spotId.isEmpty) {
    throw Exception("O id do spot não foi informado.");
  }

  await db.transaction((txn) async {


    await txn.insert(
      'parkingSpot',
      parkingSpot.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await txn.update(
      'spot',
      {'isOccupied': 1},
      where: 'id = ?',
      whereArgs: [parkingSpot.spotId],
    );
  });
}



  Future<void> insertParkingEntry(ParkingSpotModel parkingSpot) async {
    final Database db = await dbHelper.database;
    
    
    await db.insert(
      'parkingSpot',
      parkingSpot.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
 
    await db.update(
      'spot',
      {'isOccupied': 1}, 
      whereArgs: [parkingSpot.spotId],
    );
  
  }


Future<void> updateParkingExit(ParkingSpotModel parkingSpot) async {
  final Database db = await dbHelper.database;

  final updatedParkingSpot = parkingSpot.copyWith(
    exitdate: DateTime.now(),
    spotId: '', 
  );
  
  await db.update(
    'parkingSpot',
    updatedParkingSpot.toJson(),
    where: 'id = ?',
    whereArgs: [parkingSpot.id],
  );
}

Future<void> freeSpot(String spotId) async {
  final Database db = await dbHelper.database;
  await db.update(
    'spot',
    {'isOccupied': 0},
    where: 'id = ?',
    whereArgs: [spotId],
  );
}


Future<List<SpotCardInfo>> loadSpotCardInfos() async {
  final Database db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.rawQuery(
    '''
    SELECT 
      s.id AS spotId,
      s.name AS spotName,
      s.isOccupied,
      p.id AS parkingSpotId,
      p.plate,
      p.entrydate AS entryDate,
      p.exitdate AS exitDate
    FROM spot s
    LEFT JOIN parkingSpot p ON p.spotId = s.id
    '''
  );

  return maps.map((map) => SpotCardInfo.fromJson(map)).toList();
}

Future<List<ParkingSpotModel>> getParkingSpots() async {
  final Database db = await dbHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('parkingSpot');

  return maps.map((map) {
    return ParkingSpotModel(
      id: map['id'].toString(),
      plate: map['plate'].toString(),
      entrydate: map['entrydate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['entrydate'] as int)
          : null,
      exitdate: map['exitdate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['exitdate'] as int)
          : null,
      spotId: map['spotId'].toString(),
    );
  }).toList();


  
}
Future<bool> isPlateAlreadyActive(String plate) async {
  final Database db = await dbHelper.database;
  final List<Map<String, dynamic>> result = await db.query(
    'parkingSpot',
    where: 'plate = ? AND exitdate IS NULL',
    whereArgs: [plate],
  );
  return result.isNotEmpty;
}


}
