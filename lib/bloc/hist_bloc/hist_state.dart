import 'package:equatable/equatable.dart';
import 'package:clickvagas/models/spot_parking_model.dart';

abstract class HistState extends Equatable {
  const HistState();
  @override
  List<Object?> get props => [];
}

class HistInitial extends HistState {}

class HistLoading extends HistState {}

class HistLoaded extends HistState {
  final List<ParkingSpotModel> transactions;
  final int statusFilter; 
  final DateTime? startDate;
  final DateTime? endDate;
  final String search;

  const HistLoaded({
    required this.transactions,
    this.statusFilter = 0,
    this.startDate,
    this.endDate,
    this.search = '',
  });

  @override
  List<Object?> get props => [transactions, statusFilter, startDate ?? '', endDate ?? '', search];

  HistLoaded copyWith({
    List<ParkingSpotModel>? transactions,
    int? statusFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? search,
  }) {
    return HistLoaded(
      transactions: transactions ?? this.transactions,
      statusFilter: statusFilter ?? this.statusFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      search: search ?? this.search,
    );
  }
}

class HistError extends HistState {
  final String message;
  const HistError(this.message);

  @override
  List<Object?> get props => [message];
}
