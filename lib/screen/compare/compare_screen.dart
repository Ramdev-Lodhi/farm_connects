import 'package:farm_connects/models/home_data_model.dart';
import 'package:farm_connects/widgets/custom_card_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/sell_cubit/sell_cubit.dart';

class CompareScreen extends StatefulWidget {
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String? _firstselectedbrand;
  List<String> firstbrandList = [];
  String? _secondselectedbrand;
  List<String> secondbrandList = [];
  String? _secondselectedmodel;
  List<String> modelNameList = [];

  @override
  void initState() {
    super.initState();
    // Populating the brand list
    firstbrandList = HomeCubit
        .get(context)
        .homeDataModel
        ?.data
        .brands
        .map((brand) => brand.name)
        .toList() ?? [];
    secondbrandList = HomeCubit
        .get(context)
        .homeDataModel
        ?.data
        .brands
        .map((brand) => brand.name)
        .toList() ?? [];
  }

  Future<void> loadModel() async {
    if (_firstselectedbrand != null) {
      await BlocProvider.of<SellCubit>(context).getModel(_firstselectedbrand!);
      modelNameList = SellCubit
          .get(context)
          .sellDataModel
          ?.data
          .models
          .map((model) => "${model.name} (${model.hpCategory})")
          .toList() ?? [];
      setState(() {});
    }
  }

  void showmodelbottomsheet(){
    CustomCardBottomSheet(hint: "select Brand",
        items: modelNameList,
        onChanged: (value) {
          setState(() {
            _secondselectedmodel = value;
            print(_secondselectedmodel);
            // loadModel();
            // showmodelbottomsheet();// Call method to load models based on the selected brand
          });
        },  label: "model");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Tractor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First Card (Tractor 1)
            CustomCardBottomSheet(hint: "select Brand",
                items: firstbrandList,
                onChanged: (value) {
                  setState(() {
                    _firstselectedbrand = value;
                    loadModel();
                    showmodelbottomsheet();// Call method to load models based on the selected brand
                  });
                },  label: "Brand"),
            SizedBox(width: 10),
            Text(
              "Vs",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(width: 10),
            // Second Card (Tractor 2)
            CustomCardBottomSheet(hint: "select Brand",
                items: secondbrandList,
                onChanged: (value) {
                  setState(() {
                    _secondselectedbrand = value;
                    loadModel(); // Call method to load models based on the selected brand
                  });
                },  label: "Brand"),
          ],
        ),
      ),
    );
  }
}
