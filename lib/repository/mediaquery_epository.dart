import 'package:flutter/material.dart';

class MediaqueryDataSearch {
  final double searchscreenHeight;
  final double searchminHeight;
  final double searchexpandedHeight;

  MediaqueryDataSearch(BuildContext context)
      : searchscreenHeight = MediaQuery.of(context).size.height,
        searchminHeight = MediaQuery.of(context).size.height * 0.20,
        searchexpandedHeight = MediaQuery.of(context).size.height * 0.28;





}

class MediaqueryDataHist {
  final double histscreenHeight;
  final double histsearchminHeight;
  final double histsearchexpandedHeight;

  MediaqueryDataHist(BuildContext context)
      : histscreenHeight = MediaQuery.of(context).size.height,
        histsearchminHeight = MediaQuery.of(context).size.height * 0.1,
        histsearchexpandedHeight = MediaQuery.of(context).size.height * 0.14;





}