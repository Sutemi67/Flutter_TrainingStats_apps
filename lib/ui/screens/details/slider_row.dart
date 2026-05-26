import 'package:flutter/material.dart';
import 'package:flutter_training_stats_apps/ui/theme/colors.dart';

class RepsInfo extends StatefulWidget {
  const RepsInfo({super.key, required this.addRep});
  final Function addRep;
  @override
  State<RepsInfo> createState() => _RepsInfoState();
}

class _RepsInfoState extends State<RepsInfo> {
  static const _maxSliderValue = 199.0;
  static const _minSliderValue = 1.0;
  static final int _divisions = ((_maxSliderValue - _minSliderValue) * 2)
      .toInt();

  int _newRepsValue = 0;
  double _newWeightValue = 1;
  Color _repsSliderColor = Colors.red;

  void getRepsColor() {
    if (_newRepsValue >= 0 && _newRepsValue < 4) {
      setState(() {
        _repsSliderColor = Colors.red;
      });
    } else if (_newRepsValue >= 4 && _newRepsValue < 8) {
      setState(() {
        _repsSliderColor = Colors.yellow;
      });
    } else if (_newRepsValue >= 8 && _newRepsValue < 12) {
      setState(() {
        _repsSliderColor = Colors.green;
      });
    } else {
      setState(() {
        _repsSliderColor = Colors.grey;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        IconButton(
          icon: const Icon(Icons.add, size: 155),
          onPressed: () => widget.addRep(_newWeightValue, _newRepsValue),
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
                  child: Text('Weight: $_newWeightValue'),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_newWeightValue > _minSliderValue) {
                    setState(() => _newWeightValue -= 0.5);
                  }
                },
                child: const Text('-', style: TextStyle(fontSize: 35)),
              ),
              Expanded(
                child: Slider(
                  activeColor: setsSelectedColor,
                  value: _newWeightValue,
                  divisions: _divisions,
                  onChanged: (double value) => setState(
                    () => _newWeightValue = (value * 10).round() / 10,
                  ),
                  label: _newWeightValue.toString(),
                  min: _minSliderValue,
                  max: _maxSliderValue,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_newWeightValue < _maxSliderValue) {
                    setState(() => _newWeightValue += 0.5);
                  }
                },
                child: const Text('+', style: TextStyle(fontSize: 35)),
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
                padding: const EdgeInsets.all(15),
                child: SizedBox(width: 97, child: Text('Reps: $_newRepsValue')),
              ),
              TextButton(
                onPressed: () {
                  if (_newRepsValue > 0) {
                    setState(() => _newRepsValue--);
                    getRepsColor();
                  }
                },
                child: const Text('-', style: TextStyle(fontSize: 35)),
              ),
              Expanded(
                child: Slider(
                  activeColor: _repsSliderColor,
                  value: _newRepsValue.toDouble(),
                  divisions: 20,
                  onChanged: (double value) {
                    setState(() {
                      _newRepsValue = value.toInt();
                      getRepsColor();
                    });
                  },
                  label: _newRepsValue.toString(),
                  min: 0,
                  max: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_newRepsValue < 20) {
                    setState(() => _newRepsValue += 1);
                    getRepsColor();
                  }
                },
                child: const Text('+', style: TextStyle(fontSize: 35)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
