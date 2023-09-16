import 'package:flutter/material.dart';
import 'package:user/screens/plan/select.condition.screen.dart';
import 'package:user/screens/plan/select.symptom.screen.dart';

class RemedySetup extends StatefulWidget {
  @override
  _RemedySetupState createState() => _RemedySetupState();
}

class _RemedySetupState extends State<RemedySetup> {
  int step = 1;

  void _nextStep() {
    setState(() {
      step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container( // Light orange background color
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 7), // Section 1
          if (step >= 1)
            AnimatedTextWidget(
              text: "Let's create your remedy plan",
              onComplete: _nextStep,
              textColor: Color(0xFFE8AA78),
            ), // Section 2
          SizedBox(height: MediaQuery.of(context).size.height / 7), // Section 3
          if (step >= 2)
            AnimatedTextWidget(
              text: "What am I treating?",
              onComplete: _nextStep,
              textColor: Color(0xFFE8AA78), // White text color
              animationDuration: Duration(milliseconds: 50), // Faster animation
            ), // Section 4
          SizedBox(height: MediaQuery.of(context).size.height / 7), // Section 5
          if (step >= 3)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConditionsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Conditions",
                    style: TextStyle(
                      color: Colors.white, // White text color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF82CAAC), // Light Green button color
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.orangeAccent, // White text color
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SymptomsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Symptoms",
                    style: TextStyle(
                      color: Colors.white, // White text color
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF82CAAC), // Light Green button color
                  ),
                ),
              ],
            ), // Section 6
          SizedBox(height: MediaQuery.of(context).size.height / 7), // Section 7
        ],
      ),
    );
  }
}

class AnimatedTextWidget extends StatefulWidget {
  final String text;
  final Function onComplete;
  final Duration animationDuration;
  final Color textColor;

  AnimatedTextWidget({
    required this.text,
    required this.onComplete,
    this.animationDuration = const Duration(milliseconds: 100),
    required this.textColor,
  });

  @override
  _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> {
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    _animateText();
  }

  Future<void> _animateText() async {
    for (int i = 0; i < widget.text.length; i++) {
      await Future.delayed(widget.animationDuration);
      setState(() {
        _displayText = widget.text.substring(0, i + 1);
      });
    }
    widget.onComplete(); // Call the onComplete function when animation completes
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _displayText,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: widget.textColor, // Use the specified textColor
        ),
      ),
    );
  }
}
