import 'package:flutter/material.dart';

import '../details/details_screen.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen>
    with SingleTickerProviderStateMixin {
  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (builder) => DetailsScreen()),
    );
  }

  late AnimationController _controller;
  late Animation<double> _animation;
  final animationDuration = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: animationDuration, vsync: this);

    _animation = Tween<double>(
      begin: 0.7,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFocus(bool isLeft) {
    if (isLeft) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Select exercise')),
      body: Row(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _toggleFocus(true);
              }
              return false;
            },
            child: Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: .symmetric(
                    horizontal: BorderSide(width: 0.5),
                    vertical: BorderSide(width: 1),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  color: Colors.blueAccent.withAlpha(15),
                ),
                child: ListView(
                  children: List<Widget>.generate(
                    25,
                    (index) => InkWell(
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
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _toggleFocus(false);
                  }
                  return false;
                },
                child: Container(
                  width: screenWidth * (1 - _animation.value),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide(width: 1),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      color: Colors.redAccent.withAlpha(15),
                    ),
                    child: ListView(
                      children: [
                        InkWell(
                          onTap: () => _navigateToDetails(context),
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
