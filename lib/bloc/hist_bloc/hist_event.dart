import 'package:equatable/equatable.dart';


abstract class HistEvent extends Equatable {
  const HistEvent();

  @override
  List<Object?> get props => [];
}


class LoadHistEvent extends HistEvent {}


class ApplyDateFilterHistEvent extends HistEvent {
  final DateTime start;
  final DateTime end;

  const ApplyDateFilterHistEvent({required this.start, required this.end});

  @override
  List<Object?> get props => [start, end];
}

class ClearDateFilterHistEvent extends HistEvent {
  const ClearDateFilterHistEvent();
}


class ApplyStatusFilterHistEvent extends HistEvent {

  final int filterStatus; 

  const ApplyStatusFilterHistEvent(this.filterStatus);

  @override
  List<Object?> get props => [filterStatus];
}

class SearchPlateHistEvent extends HistEvent {
  final String plate;

  const SearchPlateHistEvent(this.plate);

  @override
  List<Object?> get props => [plate];
}
