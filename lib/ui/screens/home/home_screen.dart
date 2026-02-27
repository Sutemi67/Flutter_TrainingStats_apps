import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/ui/navigation.dart';
import 'package:flutter_training_stats_apps/ui/screens/home/train_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToSelect(BuildContext context) {
    Navigator.pushNamed(context, AppRoutesNames.selectRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home screen')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('How much I lifted before'),
            Placeholder(),
            TrainCard(trainDate: DateTime(2025, 11, 10), weight: 465.2),
            TrainCard(trainDate: DateTime(2025, 10, 10), weight: 465.2),
            TrainCard(trainDate: DateTime(2025, 09, 10), weight: 465.2),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () => _navigateToSelect(context),
        child: Text('Go train'),
      ),
    );
  }
}
