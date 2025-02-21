import 'package:clickvagas/bloc/bloc_plate/plate_event.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';

class PlateBloc extends Bloc<PlateEvent, PlateState> {
  final ParkingSpotRepository repository; 

  PlateBloc(this.repository) : super(PlateState(plate: '', isValid: false)) {
    on<UpdatePlate>((event, emit) {
      final formattedPlate = _formatPlate(event.plate);
      final isValid = _validatePlate(formattedPlate);
      emit(PlateState(plate: formattedPlate, isValid: isValid));
    });
  }


  Future<bool> checkIfPlateIsActive(String plate) async {
    return await repository.dataFunctions.isPlateAlreadyActive(plate);
  }

  bool _validatePlate(String plate) {
    final regexOld = RegExp(r'^[A-Z]{3}-\d{4}$'); 
    final regexNew = RegExp(r'^[A-Z]{3}\d[A-Z]\d{2}$');
    return regexOld.hasMatch(plate) || regexNew.hasMatch(plate);
  }

  String _formatPlate(String plate) {
    plate = plate.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    if (plate.length > 7) {
      plate = plate.substring(0, 7);
    }

    if (plate.length == 7) {
      if (RegExp(r'^[A-Z]{3}\d{4}$').hasMatch(plate)) {
        return '${plate.substring(0, 3)}-${plate.substring(3, 7)}'; 
      } else if (RegExp(r'^[A-Z]{3}\d[A-Z]\d{2}$').hasMatch(plate)) {
        return '${plate.substring(0, 3)}-${plate.substring(3)}'; 
      }
    }

    return plate; 
  }
}
