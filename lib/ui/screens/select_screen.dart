import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import 'details_screen.dart';

class SelectScreen extends StatelessWidget {
  @Preview(brightness: Brightness.light)
  const SelectScreen({super.key});

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => DetailsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select exercise')),
      body: Center(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _navigateToDetails(context);
              },
              child: const Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('push-ups'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
