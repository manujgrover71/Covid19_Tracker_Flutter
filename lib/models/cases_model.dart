import 'package:flutter/foundation.dart';

class CasesModel {
  final String country;
  final int cases;
  final String status;
  final DateTime recordedTime;

  CasesModel({
    @required this.country,
    @required this.cases,
    @required this.status,
    @required this.recordedTime,
  });
}
