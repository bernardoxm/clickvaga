abstract class PlateEvent {}

class UpdatePlate extends PlateEvent {
  final String plate;
  UpdatePlate(this.plate);
}

class PlateState {
  final String plate;
  final bool isValid;

  PlateState({required this.plate, required this.isValid});
}