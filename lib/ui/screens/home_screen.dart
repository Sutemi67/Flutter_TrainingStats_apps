import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_training_stats_apps/ui/screens/select_screen.dart';

class HomeScreen extends StatelessWidget {
  @Preview()
  const HomeScreen({super.key});

  void _navigateToSelect(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => SelectScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Main screen title'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('data'), Text('data')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('data'), Text('data')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('data'), Text('data')],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _navigateToSelect(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
