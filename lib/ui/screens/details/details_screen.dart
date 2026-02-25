import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<int> reps = [1, 2, 3];
  bool isRegulatorsVisible = false;
  double newRepsValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise details')),
      body: Column(
        mainAxisAlignment: .start,
        children: [
          Icon(Icons.upload_file_outlined, size: 200),
          Card(
            child: InkWell(
              onTap: () => setState(() {
                isRegulatorsVisible = !isRegulatorsVisible;
              }),
              child: isRegulatorsVisible
                  ? Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(Icons.add, size: 155),
                        Row(
                          children: [
                            Text('Reps'),
                            Icon(Icons.eighteen_mp),
                            Expanded(
                              child: Slider(
                                value: newRepsValue,
                                divisions: 10,
                                onChanged: (double value) {
                                  setState(() {
                                    newRepsValue = value;
                                  });
                                },
                                label: newRepsValue.toString(),
                                min: 0,
                                max: 10,
                              ),
                            ),
                            Icon(Icons.add),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: .center,
                      children: [Icon(Icons.add, size: 55)],
                    ),
            ),
          ),
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
