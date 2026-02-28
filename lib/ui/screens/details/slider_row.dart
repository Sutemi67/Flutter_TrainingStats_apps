import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';

class RepsInfo extends StatefulWidget {
  const RepsInfo({super.key, required this.addRep});
  final Function addRep;
  @override
  State<RepsInfo> createState() => _RepsInfoState();
}

class _RepsInfoState extends State<RepsInfo> {
  int newRepsValue = 0;
  double newWeightValue = 0;
  Color repsSliderColor = Colors.red;

  void getRepsColor() {
    if (newRepsValue >= 0 && newRepsValue < 4) {
      setState(() {
        repsSliderColor = Colors.red;
      });
    } else if (newRepsValue >= 4 && newRepsValue < 8) {
      setState(() {
        repsSliderColor = Colors.yellow;
      });
    } else if (newRepsValue >= 8 && newRepsValue < 12) {
      setState(() {
        repsSliderColor = Colors.green;
      });
    } else {
      setState(() {
        repsSliderColor = Colors.grey;
      });
    }
  }

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
          surfaceTintColor: setsMainColor,
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
                onPressed: () {
                  if (newWeightValue > 0) {
                    setState(() => newWeightValue -= 0.5);
                  }
                },
                child: Text('-', style: TextStyle(fontSize: 35)),
              ),
              Expanded(
                child: Slider(
                  activeColor: setsSelectedColor,
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
                onPressed: () {
                  if (newWeightValue < 200) {
                    setState(() => newWeightValue += 0.5);
                  }
                },
                child: Text('+', style: TextStyle(fontSize: 35)),
              ),
            ],
          ),
        ),
        Card(
          surfaceTintColor: exerciseMainColor,
          child: Row(
            crossAxisAlignment: .center,
            children: [
              Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(width: 97, child: Text('Reps: $newRepsValue')),
              ),
              TextButton(
                onPressed: () {
                  if (newRepsValue > 0) {
                    setState(() => newRepsValue--);
                    getRepsColor();
                  }
                },
                child: Text('-', style: TextStyle(fontSize: 35)),
              ),
              Expanded(
                child: Slider(
                  activeColor: repsSliderColor,
                  value: newRepsValue.toDouble(),
                  divisions: 20,
                  onChanged: (double value) {
                    setState(() {
                      newRepsValue = value.toInt();
                      getRepsColor();
                    });
                  },
                  label: newRepsValue.toString(),
                  min: 0,
                  max: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (newRepsValue < 20) {
                    setState(() => newRepsValue += 1);
                    getRepsColor();
                  }
                },
                child: Text('+', style: TextStyle(fontSize: 35)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
