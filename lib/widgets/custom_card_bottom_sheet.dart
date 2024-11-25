import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardBottomSheet extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String label;


  const CustomCardBottomSheet({
    Key? key,
    required this.hint,
    required this.items,
    this.value,
    required this.onChanged,
    required this.label,
  }) : super(key: key);

  @override
  _CustomCardBottomSheet createState() => _CustomCardBottomSheet();
}

class _CustomCardBottomSheet extends State<CustomCardBottomSheet> {
  List<String> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  String? selectedItem;

  @override
  void initState() {
    super.initState();
    // Initialize the filteredItems list and selectedItem
    filteredItems = List.from(widget.items);
    selectedItem = widget.value; // Initialize with the provided value
  }

  void filterData(String text) {
    setState(() {
      filteredItems = widget.items.where((item) {
        return item.toLowerCase().contains(text.toLowerCase());
      }).toList();
    });
  }

  void _showBottomSheet() {
    // Reset filteredItems to the original list
    filteredItems = List.from(widget.items);
    searchController.clear(); // Clear the search field

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                          widget.hint ,
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
                        hintText: 'Search ${widget.label}',
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
                    child: filteredItems.isNotEmpty
                        ? ListView.builder(
                      controller: scrollController,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredItems[index]),
                          tileColor: filteredItems[index] == selectedItem
                              ? Colors.blue.withOpacity(0.3)
                              : null,
                          onTap: () {
                            setState(() {
                              selectedItem = filteredItems[index]; // Update selected item
                            });
                            widget.onChanged(filteredItems[index]);
                            Navigator.pop(context);
                          },
                        );
                      },
                    )
                        : Center(child: Text('No items found')), // Display message if no items
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showBottomSheet,
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
                widget.label,
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
    );
  }
}
