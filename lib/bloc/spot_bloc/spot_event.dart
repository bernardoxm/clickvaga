import 'package:equatable/equatable.dart';
import 'package:clickvagas/models/spot_model.dart';

abstract class SpotEvent extends Equatable {
  const SpotEvent();

  @override
  List<Object?> get props => [];
}

class LoadSpotsEvent extends SpotEvent {}

class AddSpotEvent extends SpotEvent {
  final SpotModel spot;
  const AddSpotEvent(this.spot);

  @override
  List<Object?> get props => [spot];
}

class RemoveLastSpotEvent extends SpotEvent {}

class RegistryEntryEvent extends SpotEvent {
  final SpotModel spot;
  final String plate;
  const RegistryEntryEvent({required this.spot, required this.plate});

  @override
  List<Object?> get props => [spot, plate];
}

class RegistryExitEvent extends SpotEvent {
  final SpotModel spot;
  const RegistryExitEvent(this.spot);

  @override
  List<Object?> get props => [spot];
}

class ApplyFilterEvent extends SpotEvent {
  final int filterStatus; 
  const ApplyFilterEvent(this.filterStatus);

  @override
  List<Object?> get props => [filterStatus];
}

class SearchPlateEvent extends SpotEvent {
  final String plate;
  const SearchPlateEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}


