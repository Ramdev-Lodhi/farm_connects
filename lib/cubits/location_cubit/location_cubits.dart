import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'location_states.dart';

class LocationCubits extends Cubit<LocationState> {
  LocationCubits() : super(LocationInitialState());
  static LocationCubits get(context) => BlocProvider.of(context);
  List<String> stateNames = [];

  Future<void> loadStates() async {
    emit(LocationUpdateLoading());
    try {
      String jsonString = await rootBundle.loadString('assets/state.json');
      final List<dynamic> statesJson = json.decode(jsonString)['states'];
      // Populate state names
      stateNames = List<String>.from(
          statesJson.map((state) => state['name']['en'] as String));
      emit(LocationUpdateLoading());
    } catch (error) {
      emit(LocationUpdateLoading());
    }
  }

  Future<List<District>> loadDistricts(String selectedState) async {
    print(selectedState);
    try {
      String jsonString =
      await rootBundle.loadString('assets/states/$selectedState.json');
      final List<dynamic> districtJson = json.decode(jsonString)['districts'];
      return districtJson
          .map((district) => District.fromJson(district))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class District {
  final String district;
  final List<SubDistrict> subDistricts;

  District({required this.district, required this.subDistricts});

  factory District.fromJson(Map<String, dynamic> json) {
    var subDistrictList = json['subDistricts'] as List;
    List<SubDistrict> subDistricts =
    subDistrictList.map((i) => SubDistrict.fromJson(i)).toList();
    return District(district: json['district'], subDistricts: subDistricts);
  }
}

class SubDistrict {
  final String subDistrict;
  final List<String> villages;
  SubDistrict({required this.subDistrict, required this.villages});

  factory SubDistrict.fromJson(Map<String, dynamic> json) {
    return SubDistrict(
      subDistrict: json['subDistrict'] ?? '',
      villages: json['villages'] != null
          ? List<String>.from(json['villages'])
          : [], // Default to empty list if null
    );
  }
}
