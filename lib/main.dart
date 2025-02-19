import 'package:clickvagas/bloc/bloc_plate/plate_bloc.dart';
import 'package:clickvagas/pages/Navi_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PlateBloc>(
          create: (context) => PlateBloc(),
        ),
       
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickVagas',
      theme: ThemeData(
        appBarTheme: AppBarTheme(centerTitle: true,

          titleTextStyle: TextStyle(  
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 20),  
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor:  Color.fromRGBO(69, 77, 102, 1), //cor da raro
        ),
        textTheme: GoogleFonts.montserratTextTheme(), //Font raro
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(68, 194, 253, 1), //cor da raro
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
