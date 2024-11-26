import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';

class CompareExpansionTile extends StatelessWidget {
  final String title;
  final List<Map<String, String>> details;
  final bool isExpanded;
  final VoidCallback onTap;

  const CompareExpansionTile({
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
            title: Text(title,style: TextStyle(color: cubit.isDark? Colors.white : Colors.black),),
            trailing: Icon(isExpanded
                ? Icons.arrow_drop_up
                : Icons.arrow_drop_down,color: cubit.isDark ? Colors.white : Colors.black,),
            onTap: onTap,
          ),
        ),

        // Only show the table when expanded
        if (isExpanded)
          Column(
            children: [
              // Iterate over each detail and display the name with its respective values below
              for (var detail in details)
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Column(
                    children: [
                      // Display the name of the detail (key)
                      Container(
                        width: double.infinity,
                        color: cubit.isDark ? Colors.white : Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            detail.keys.first,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Table(
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  color: cubit.isDark ? Colors.white : Colors.black12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      detail.values.isNotEmpty
                                          ? detail.values.first.split(',')[0].trim()
                                          : '',
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  color: cubit.isDark ? Colors.white : Colors.black12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      detail.values.isNotEmpty
                                          ? detail.values.first.split(',')[1].trim()
                                          : '',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
