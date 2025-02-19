class ParkingState{
final List<String> occupiedSpots;
final int totalSpots;

ParkingState({required this.occupiedSpots, required this.totalSpots});

int get availableSpots => totalSpots - occupiedSpots.length;

}