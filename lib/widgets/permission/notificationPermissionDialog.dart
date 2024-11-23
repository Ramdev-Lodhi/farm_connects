import 'package:flutter/material.dart';

class NotificationPermissionDialog extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onEnable;
  final VoidCallback onDeny;

  const NotificationPermissionDialog({
    Key? key,
    required this.isDarkMode,
    required this.onEnable,
    required this.onDeny,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      title: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.notifications_active,
          color: Colors.blue,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Allow Farm Connects to send you notifications?",
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
        ],
      ),
      actions: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: onEnable,
                child: Text("Enable", style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: onDeny,
                child: Text("Don't allow", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      contentPadding: EdgeInsets.all(20),
    );
  }
}
