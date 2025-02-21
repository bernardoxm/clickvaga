
import 'package:equatable/equatable.dart';
import 'package:clickvagas/models/spot_card_info.dart';
import 'package:clickvagas/models/spot_model.dart';
import 'package:clickvagas/models/spot_parking_model.dart';

abstract class SpotState extends Equatable {
  const SpotState();

  @override
  List<Object?> get props => [];
}

class SpotInitial extends SpotState {}

class SpotLoading extends SpotState {}

class SpotLoaded extends SpotState {
  final List<SpotModel> spots;
  final List<ParkingSpotModel> parkingEntries;
  final List<SpotCardInfo> spotCardInfos;
  final int filterStatus; 
  final String search;

  const SpotLoaded({
    required this.spots,
    required this.parkingEntries,
    required this.spotCardInfos,
    this.filterStatus = 0,
    this.search = '',
  });

  @override
  List<Object?> get props => [spots, parkingEntries, spotCardInfos, filterStatus, search];

  SpotLoaded copyWith({
    List<SpotModel>? spots,
    List<ParkingSpotModel>? parkingEntries,
    List<SpotCardInfo>? spotCardInfos,
    int? filterStatus,
    String? search,
  }) {
    return SpotLoaded(
      spots: spots ?? this.spots,
      parkingEntries: parkingEntries ?? this.parkingEntries,
      spotCardInfos: spotCardInfos ?? this.spotCardInfos,
      filterStatus: filterStatus ?? this.filterStatus,
      search: search ?? this.search,
    );
  }
}

class SpotError extends SpotState {
  final String message;
  const SpotError(this.message);

  @override
  List<Object?> get props => [message];
}


