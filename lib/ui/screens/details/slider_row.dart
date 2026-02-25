import 'package:flutter/material.dart';

class RepsInfo extends StatefulWidget {
  const RepsInfo({super.key, required this.addRep});
  final Function addRep;
  @override
  State<RepsInfo> createState() => _RepsInfoState();
}

class _RepsInfoState extends State<RepsInfo> {
  int newRepsValue = 0;
  double newWeightValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        IconButton(
          icon: Icon(Icons.add, size: 155),
          onPressed: () => widget.addRep(newWeightValue, newRepsValue),
        ),
        Card(
          surfaceTintColor: Colors.blue,
          child: Row(
            crossAxisAlignment: .center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: 97,
                  child: Text('Weight: $newWeightValue'),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => newWeightValue -= 0.5),
                child: Text('-', style: TextStyle(fontSize: 35)),
              ),
              Expanded(
                child: Slider(
                  value: newWeightValue,
                  divisions: 400,
                  onChanged: (double value) => setState(
                    () => newWeightValue = (value * 10).round() / 10,
                  ),
                  label: newWeightValue.toString(),
                  min: 0,
                  max: 200,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => newWeightValue += 0.5),
                child: Text('+', style: TextStyle(fontSize: 35)),
              ),
            ],
          ),
        ),
        Card(
          surfaceTintColor: Colors.greenAccent,
          child: Row(
            crossAxisAlignment: .center,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(width: 97, child: Text('Reps: $newRepsValue')),
              ),
              TextButton(
                onPressed: () => setState(() => newRepsValue--),
                child: Text('-', style: TextStyle(fontSize: 35)),
              ),
              Expanded(
                child: Slider(
                  value: newRepsValue.toDouble(),
                  divisions: 20,
                  onChanged: (double value) {
                    setState(() {
                      newRepsValue = value.toInt();
                    });
                  },
                  label: newRepsValue.toString(),
                  min: 0,
                  max: 20,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => newRepsValue += 1),
                child: Text('+', style: TextStyle(fontSize: 35)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
