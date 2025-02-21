import 'package:bloc_test/bloc_test.dart';
import 'package:clickvagas/bloc/spot_bloc/spot_bloc.dart';
import 'package:clickvagas/bloc/spot_bloc/spot_event.dart';
import 'package:clickvagas/bloc/spot_bloc/spot_state.dart';
import 'package:clickvagas/pages/parking_spots_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clickvagas/models/spot_model.dart';
import 'package:clickvagas/models/spot_parking_model.dart';
import 'package:clickvagas/models/spot_card_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';


import 'parking_spot_repository_test.mocks.dart';

void main() {
  late MockParkingSpotRepository mockRepository;
  late SpotBloc spotBloc;

 
  final spot1 = SpotModel(id: "1", name: "Spot 0", isOccupied: false);
  final spot2 = SpotModel(id: "2", name: "Spot 1", isOccupied: true);
  final parkingEntry1 = ParkingSpotModel(
    id: "p1",
    spotId: "1",
    plate: "AAA-1111",
    entrydate: DateTime(2023, 1, 1, 10, 0),
    exitdate: null,
  );
  final cardInfo1 = SpotCardInfo(
    spotId: "1",
    spotName: "Spot 0",
    isOccupied: false,
    parkingSpotId: "p1",
    plate: "AAA-1111",
    entryDate: DateTime(2023, 1, 1, 10, 0),
    exitDate: null,
  );

  setUp(() {
    mockRepository = MockParkingSpotRepository();
    spotBloc = SpotBloc(repository: mockRepository);
  });

  tearDown(() {
    spotBloc.close();
  });

  group('SpotBloc Tests', () {
    blocTest<SpotBloc, SpotState>(
      'SpotLoading e depois SpotLoaded ao carregar dados',
      build: () {
        when(mockRepository.loadSpots()).thenAnswer((_) async => [spot1, spot2]);
        when(mockRepository.getParkingSpots()).thenAnswer((_) async => [parkingEntry1]);
        when(mockRepository.loadSpotCardInfos()).thenAnswer((_) async => [cardInfo1]);
        return spotBloc;
      },
      act: (bloc) => bloc.add(LoadSpotsEvent()),
      expect: () => [
        isA<SpotLoading>(),
        isA<SpotLoaded>().having((state) => state.spots.length, 'spots length', 2
        ),
      ],
    );
  });

  group('ParkingSpotsPage Widget Tests', () {
    testWidgets('Indicador de carregamento quando o estado é loading', (WidgetTester tester) async {
    
      spotBloc.emit(SpotLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SpotBloc>.value(
            value: spotBloc,
            child: const ParkingSpotsPage(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Lista de vagas quando o estado é SpotLoaded', (WidgetTester tester) async {
      final loadedState = SpotLoaded(
        spots: [spot1, spot2],
        parkingEntries: [parkingEntry1],
        spotCardInfos: [cardInfo1],
      );
      spotBloc.emit(loadedState);
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SpotBloc>.value(
            value: spotBloc,
            child: const ParkingSpotsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      expect(find.textContaining("Spot"), findsWidgets);
    });
  });
}
