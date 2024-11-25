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
  String? _firstselectemodel;
  List<String> firstbrandList = [];
  String? _secondselectedbrand;
  List<String> secondbrandList = [];
  String? _secondselectedmodel;
  List<String> modelNameList = [];

  @override
  void initState() {
    super.initState();
     // loadModel();
    // Populating the brand list
    firstbrandList = HomeCubit.get(context)
            .homeDataModel
            ?.data
            .brands
            .map((brand) => brand.name)
            .toList() ??
        [];
    secondbrandList = HomeCubit.get(context)
            .homeDataModel
            ?.data
            .brands
            .map((brand) => brand.name)
            .toList() ??
        [];

  }

  Future<void> loadModel() async {
    if (_firstselectedbrand != null) {
      await BlocProvider.of<SellCubit>(context).getModel(_firstselectedbrand!);
      modelNameList = SellCubit.get(context)
              .sellDataModel
              ?.data
              .models
              .map((model) => "${model.name} (${model.hpCategory})")
              .toList() ??
          [];
      setState(() {});
    }
  }

  Future<void> showModelBottomSheet() {
    print(modelNameList);
    return showCustomCardBottomSheet(
      context: context,
      hint: "Select an Item",
      label: "Item",
      items: modelNameList,
      selectedValue: _firstselectemodel,
      onChanged: (value) {
        setState(() {
          _firstselectemodel = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Tractor"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showCustomCardBottomSheet(
                      context: context,
                      hint: "Select an Item",
                      label: "Item",
                      items: firstbrandList,
                      selectedValue: _firstselectedbrand,
                      onChanged: (value) {


                        // Use a temporary synchronous update to store the selected value
                        setState(() {
                          _firstselectedbrand = value;
                        });
                        if (_firstselectedbrand != null) {
                          loadModel().then((_) {
                            setState(() {
                              // Show the bottom sheet after async operation
                              showModelBottomSheet();
                            });
                          });
                        }
                      },
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                      width: 130,
                      height: 220,
                      padding: const EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Brand',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                GestureDetector(
                  onTap: () {
                    showCustomCardBottomSheet(
                      context: context,
                      hint: "Select an Item",
                      label: "Item",
                      items: firstbrandList,
                      selectedValue: _firstselectedbrand,
                      onChanged: (value) {
                        setState(() {
                          _firstselectedbrand = value;
                        });
                      },
                    );
                  },
                  child: Card(
                    elevation: 3,
                    child: Container(
                      width: 130,
                      height: 220,
                      padding: const EdgeInsets.all(8),
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Brand',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // _firstselectedbrand != null ? showModelBottomSheet() : Container(),
          ],
        ),
      ),
    );
  }
}
