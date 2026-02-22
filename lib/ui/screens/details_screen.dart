import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<int> reps = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise details')),
      body: Column(
        mainAxisAlignment: .start,
        children: [
          Icon(Icons.upload_file_outlined, size: 200),
          Expanded(
            child: reps.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: reps.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(title: Text('${reps[index]} reps')),
                      ),
                    ),
                  )
                : Text('reps are empty'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('add reps'),
      ),
    );
  }
}
