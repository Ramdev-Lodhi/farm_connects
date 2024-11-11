import 'package:flutter/material.dart';

class SellRentDialog extends StatelessWidget {
  final VoidCallback onSell;
  final VoidCallback onRent;
  final bool isDark;

  const SellRentDialog({
    Key? key,
    required this.onSell,
    required this.onRent,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose an Option",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(
                thickness: 1.5,
                color: Colors.black12,
                height: 10,
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 0),
                child: SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onSell();
                    },
                    child:
                    Text("Sell", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(bottom: 0), // Set bottom margin to 0
                child: SizedBox(
                  width: 80, // Set the desired width here
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onSell();
                    },
                    child:
                    Text("Rent", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
