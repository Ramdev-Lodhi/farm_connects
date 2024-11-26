import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
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
    HomeCubit cubit = HomeCubit.get(context);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: ListTile(
            title: Text(title,style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),),
            trailing: Icon(isExpanded
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down,color: cubit.isDark ? Colors.white : Colors.black,),
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
                      color:cubit.isDark ? Colors.white : Colors.black12,
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
                      color:cubit.isDark ? Colors.white : Colors.black12,
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
