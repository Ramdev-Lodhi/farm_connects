import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryPicker extends StatefulWidget {
  CountryPicker({
    required this.callBackFunction,
    this.headerText,
    this.headerBackgroundColor,
    this.headerTextColor,
  });

  final Function callBackFunction;
  final String? headerText;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;
  bool isInit = true;

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  List<CountryModel>? countryList = [];
  CountryModel? selectedCountryData;

  @override
  void didChangeDependencies() async {
    if (widget.isInit) {
      widget.isInit = false;
      final data = await DefaultAssetBundle.of(context)
          .loadString('assets/countrycodes.json');
      setState(() {
        countryList = parseJson(data);
        selectedCountryData = countryList!.firstWhere(
              (country) => country.name == "India",
          orElse: () => countryList![0],
        );
      });
      widget.callBackFunction(selectedCountryData!.name,
          selectedCountryData!.dialCode, selectedCountryData!.flag);
    }
    super.didChangeDependencies();
  }

  List<CountryModel> parseJson(String response) {
    final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<CountryModel>((json) => CountryModel.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        showDialogue(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            selectedCountryData?.flag ?? '',
            style: TextStyle(fontSize: 20.sp),
          ),
          SizedBox(width: 10.w),
          Text(
            selectedCountryData?.dialCode ?? '',
            style: TextStyle(fontSize: 20.sp),
          ),
          Icon(
            Icons.arrow_drop_down_outlined,
            size: 30.sp,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Future<void> showDialogue(BuildContext context) async {
    final countryData = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) => CustomDialog(
        searchList: countryList,
        callBackFunction: widget.callBackFunction,
        headerText: widget.headerText ?? 'Select Country',
        headerBackgroundColor: widget.headerBackgroundColor ?? Colors.blue,
        headerTextColor: widget.headerTextColor ?? Colors.white,
      ),
    );
    if (countryData != null) {
      setState(() {
        selectedCountryData = countryData as CountryModel;
      });
    }
  }
}

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    required this.searchList,
    required this.callBackFunction,
    this.headerText,
    this.headerBackgroundColor,
    this.headerTextColor,
  });

  final List<CountryModel>? searchList;
  final Function callBackFunction;
  final String? headerText;
  final Color? headerBackgroundColor;
  final Color? headerTextColor;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  List<CountryModel> tmpList = [];

  @override
  void initState() {
    super.initState();
    tmpList = widget.searchList!;
  }

  void filterData(String text) {
    tmpList = widget.searchList!.where((country) {
      return country.name!.toLowerCase().contains(text.toLowerCase());
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.75.sh,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        children: [
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: widget.headerBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.headerText ?? 'Select Country',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: widget.headerTextColor,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: widget.headerTextColor),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Search Country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(36),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
              ),
              onChanged: filterData,
            ),
          ),
          const Divider(color: Colors.grey, height: 1.0),
          Expanded(
            child: ListView.builder(
              itemCount: tmpList.length,
              itemBuilder: (context, index) {
                final country = tmpList[index];
                return ListTile(
                  leading: Text(
                    country.flag!,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  title: Text(
                    country.name!,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  trailing: Text(
                    country.dialCode!,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context, country);
                    widget.callBackFunction(
                      country.name,
                      country.dialCode,
                      country.flag,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CountryModel {
  const CountryModel({
    required this.name,
    required this.dialCode,
    required this.code,
    required this.flag,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    final flag = CountryModel.getEmojiFlag(json['code']);
    return CountryModel(
      name: json['name'] as String,
      dialCode: json['dial_code'] as String,
      code: json['code'] as String,
      flag: flag,
    );
  }

  final String? name, dialCode, code, flag;

  static String getEmojiFlag(String emojiString) {
    const flagOffset = 0x1F1E6;
    const asciiOffset = 0x41;

    final firstChar = emojiString.codeUnitAt(0) - asciiOffset + flagOffset;
    final secondChar = emojiString.codeUnitAt(1) - asciiOffset + flagOffset;

    return String.fromCharCode(firstChar) + String.fromCharCode(secondChar);
  }
}
