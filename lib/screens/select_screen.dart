import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/screens/details_screen.dart';

class SelectScreen extends StatelessWidget {
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
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
