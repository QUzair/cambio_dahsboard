import 'dart:collection';

import 'dart:convert';

class Driver {
  final String driverName;
  final String driverDescription;
  final double scoreVal;
  final List<Lever> levers;

  Driver({this.driverName, this.driverDescription, this.levers, this.scoreVal});

  Driver.fromJson(Map<String, dynamic> json)
      : driverName = json['driverName'],
        driverDescription = json['driverDescription'],
        scoreVal = json['scoreVal'],
        levers = List<Lever>.from(
            json['levers'].map((data) => Lever.fromJson(data)));
}

class Lever {
  final String leverName;
  final String leverDescription;
  final List<KPI> kpis;

  Lever({this.leverName, this.leverDescription, this.kpis});

  Lever.fromJson(Map<String, dynamic> json)
      : leverName = json['leverName'],
        leverDescription = json['leverDescription'],
        kpis = List<KPI>.from(json['kpis'].map((data) => KPI.fromJson(data)));
}

class KPI {
  final String kpiQuestion;
  final String valueType;
  final double value;
  final List<Value> values;

  KPI({this.kpiQuestion, this.valueType, this.value,this.values});

  KPI.fromJson(Map<String, dynamic> json)
      : kpiQuestion = json['kpiQuestion'],
        valueType = json['valueType'],
        value = json['value'],
        values = json['coordinates']==null? []: List<Value>.from(json['coordinates'].map((data) => Value.fromJson(data)));
}

class Value {
  final String x;
  final double y;

  Value({this.x, this.y});

  Value.fromJson(Map<String, dynamic> json)
      : x = json['xValue'],
        y = json['yValue'];
}
