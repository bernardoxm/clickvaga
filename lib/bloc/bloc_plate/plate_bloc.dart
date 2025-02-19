import 'package:clickvagas/bloc/bloc_plate/plate_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlateBloc extends Bloc<PlateEvent, PlateState> {
  PlateBloc() : super(PlateState(plate: '', isValid: false)) {
    on<UpdatePlate>((event, emit) {
      final formattedPlate = _formatPlate(event.plate);
      final isValid = _validatePlate(formattedPlate);
      emit(PlateState(plate: formattedPlate, isValid: isValid));
    });
  }

  bool _validatePlate(String plate) {
  final regexOld = RegExp(r'^[A-Z]{3}-\d{4}$'); // Padrão antigo: AAA-1234
  final regexNew = RegExp(r'^[A-Z]{3}\d[A-Z]\d{2}$'); // Padrão novo: AAA1A23
  return regexOld.hasMatch(plate) || regexNew.hasMatch(plate);
}
  String _formatPlate(String plate) {
  plate = plate.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

  if (plate.length > 7) {
    plate = plate.substring(0, 7); // Garante que a placa não tenha mais de 7 caracteres
  }

  if (plate.length == 7) {
    if (RegExp(r'^[A-Z]{3}\d{4}$').hasMatch(plate)) {
      return '${plate.substring(0, 3)}-${plate.substring(3, 7)}'; // Formato AAA-1234
    } else if (RegExp(r'^[A-Z]{3}\d[A-Z]\d{2}$').hasMatch(plate)) {
      return '${plate.substring(0, 3)}-${plate.substring(3)}'; // Formato AAA-1A23
    }
  }

  return plate; // Mantém o formato enquanto o usuário digita
}
}