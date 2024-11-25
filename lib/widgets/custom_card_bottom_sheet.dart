import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showCustomCardBottomSheet({
  required BuildContext context,
  required String hint,
  required String label,
  required List<String> items,
  required String? selectedValue,
  required ValueChanged<String?> onChanged,
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      TextEditingController searchController = TextEditingController();
      List<String> filteredItems = List.from(items);

      void filterData(String text) {
        filteredItems = items
            .where((item) => item.toLowerCase().contains(text.toLowerCase()))
            .toList();
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hint,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          hintText: 'Search $label',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 14.0),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                        ),
                        onChanged: (text) {
                          setState(() {
                            filterData(text);
                          });
                        },
                      ),
                    ),
                    const Divider(color: Colors.grey, height: 1.0),
                    Expanded(
                      child: filteredItems.isNotEmpty
                          ? ListView.builder(
                        controller: scrollController,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredItems[index]),
                            tileColor: filteredItems[index] == selectedValue
                                ? Colors.blue.withOpacity(0.3)
                                : null,
                            onTap: () {
                              onChanged(filteredItems[index]);
                              Navigator.pop(context);
                            },
                          );
                        },
                      )
                          : Center(child: Text('No items found')),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}
