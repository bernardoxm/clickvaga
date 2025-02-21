import 'package:bloc_test/bloc_test.dart';
import 'package:clickvagas/bloc/hist_bloc/hist_bloc.dart';
import 'package:clickvagas/bloc/hist_bloc/hist_event.dart';
import 'package:clickvagas/bloc/hist_bloc/hist_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'package:mockito/mockito.dart';

import 'parking_spot_repository_test.mocks.dart';

void main() {
  late MockParkingSpotRepository mockRepository;
  late HistBloc histBloc;

  
  final transaction1 = ParkingSpotModel(
    id: '1',
    spotId: 'spot1',
    plate: 'AAA-1111',
    entrydate: DateTime(2023, 1, 1, 10, 0),
    exitdate: null,
  );
  final transaction2 = ParkingSpotModel(
    id: '2',
    spotId: 'spot2',
    plate: 'BBB-2222',
    entrydate: DateTime(2023, 1, 1, 11, 0),
    exitdate: DateTime(2023, 1, 1, 12, 0),
  );

  setUp(() {
    mockRepository = MockParkingSpotRepository();
    histBloc = HistBloc(repository: mockRepository);
  });

  tearDown(() {
    histBloc.close();
  });

  group('HistBloc Tests', () {
    blocTest<HistBloc, HistState>(
      'Emitir HistLoading seguido de HistLoaded ao carregar transações',
      build: () {
        when(mockRepository.getParkingSpots()).thenAnswer((_) async => [transaction1, transaction2]);
        return histBloc;
      },
      act: (bloc) => bloc.add(LoadHistEvent()),
      expect: () => [
        isA<HistLoading>(),
        isA<HistLoaded>().having((state) => state.transactions.length, 'Número de transações', 2),
      ],
    );

    blocTest<HistBloc, HistState>(
      'Filtrar transações ativas (exitdate == null)',
      build: () {
        when(mockRepository.getParkingSpots()).thenAnswer((_) async => [transaction1, transaction2]);
        return histBloc;
      },
      act: (bloc) async {
        bloc.add(LoadHistEvent());
        await Future.delayed(Duration.zero);
        bloc.add(const ApplyStatusFilterHistEvent(1));
      },
      expect: () => [
        isA<HistLoading>(),
        isA<HistLoaded>(),
        isA<HistLoaded>().having((state) => state.transactions.length, 'Transações ativas', 1),
      ],
    );

    blocTest<HistBloc, HistState>(
      'Filtrar transações finalizadas (exitdate != null)',
      build: () {
        when(mockRepository.getParkingSpots()).thenAnswer((_) async => [transaction1, transaction2]);
        return histBloc;
      },
      act: (bloc) async {
        bloc.add(LoadHistEvent());
        await Future.delayed(Duration.zero);
        bloc.add(const ApplyStatusFilterHistEvent(2));
      },
      expect: () => [
        isA<HistLoading>(),
        isA<HistLoaded>(),
        isA<HistLoaded>().having((state) => state.transactions.length, 'Transações finalizadas', 1),
      ],
    );

    blocTest<HistBloc, HistState>(
      'Filtrar transações por placa',
      build: () {
        when(mockRepository.getParkingSpots()).thenAnswer((_) async => [transaction1, transaction2]);
        return histBloc;
      },
      act: (bloc) async {
        bloc.add(LoadHistEvent());
        await Future.delayed(Duration.zero);
        bloc.add(const SearchPlateHistEvent("AAA"));
      },
      expect: () => [
        isA<HistLoading>(),
        isA<HistLoaded>(),
        isA<HistLoaded>().having((state) => state.transactions.length, 'Transações filtradas por placa', 1),
      ],
    );
  });
}
