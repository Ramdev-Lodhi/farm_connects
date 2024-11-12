import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final List<Map<String, String>> details;
  final bool isExpanded;
  final VoidCallback onTap;

  const CustomExpansionTile({
    required this.title,
    required this.details,
    required this.isExpanded,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: ListTile(
            title: Text(title),
            trailing: Icon(isExpanded
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down),
            onTap: onTap,
          ),
        ),

        if (isExpanded)
          Table(
            children: details.map((detail) {
              var name = detail.keys.first;
              var value = detail.values.first;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color:Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      color:Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(value),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}
