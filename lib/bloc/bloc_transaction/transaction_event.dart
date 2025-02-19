abstract class ParkingEvent{}

class AddVehicle extends ParkingEvent{
  final String  plate;
  AddVehicle(this.plate);
}


class RemoveVehicle extends ParkingEvent{
  final String plate;
  RemoveVehicle(this.plate);
}


