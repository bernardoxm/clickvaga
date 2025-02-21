import 'package:clickvagas/bloc/bloc_plate/plate_bloc.dart';
import 'package:clickvagas/bloc/hist_bloc/hist_bloc.dart';
import 'package:clickvagas/bloc/spot_bloc/spot_bloc.dart';
import 'package:clickvagas/data/data_base.dart';
import 'package:clickvagas/pages/Navi_page.dart';
import 'package:clickvagas/repository/data_color.dart';
import 'package:clickvagas/repository/data_text.dart';
import 'package:clickvagas/repository/parking_spot_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dbHelper = DatabaseHelper();
  Database db = await dbHelper.database;
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlateBloc>(
          create: (context) => PlateBloc(ParkingSpotRepository()),
        ),
        BlocProvider<SpotBloc>(
          create: (context) => SpotBloc(repository: ParkingSpotRepository()),
        ),
        BlocProvider<HistBloc>(
          create: (context) => HistBloc(repository: ParkingSpotRepository()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  DataColor dataColors = DataColor();
  DataText    dataText = DataText();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: dataText.textTitle,
      theme: ThemeData(
        dialogTheme: DialogTheme(
          backgroundColor: dataColors.colorWhite,
          titleTextStyle: TextStyle(
            color: dataColors.colorRaroBlueDark, 
            fontFamily: 'Montserrat',
             fontWeight: FontWeight.bold,
             fontSize: 20,
          ),
          contentTextStyle: TextStyle(
            color: dataColors.colorRaroBlueDark, 
            fontFamily: 'Montserrat',
          ),
          
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all(
              TextStyle(
                color: dataColors.colorWhite,
                fontFamily: 'Montserrat',
              ),
            ),
            backgroundColor: WidgetStateProperty.all(
                dataColors.colorRaroBlueDark 
                ),
          ),
        ),
        appBarTheme: AppBarTheme(
            centerTitle: true,
            titleTextStyle: TextStyle(
                color: dataColors.colorWhite,
                fontFamily: 'Montserrat',
                fontSize: 20),
            iconTheme: IconThemeData(
              color: dataColors.colorWhite,
            ),
            backgroundColor: dataColors.colorRaroBlueDark 
            ),
        textTheme: GoogleFonts.montserratTextTheme(), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: dataColors.colorRaroBlue, 
        ),
      ),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: NaviPage(),
    );
  }
}
