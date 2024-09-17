import 'package:cat_feed/feed.dart';
import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final FeedItem feedItem;
  final ValueChanged<bool> onToggle;

  const ToggleSwitch({super.key, required this.feedItem, required this.onToggle});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool light = true;

  @override
  void initState() {
    super.initState();

    DateTime feedDateTime = widget.feedItem.created;
    DateTime feedDate = DateTime(feedDateTime.year, feedDateTime.month, feedDateTime.day);
    int feedDateTimeMinus12 = feedDateTime.hour - 12;
    
    DateTime now = DateTime.now().add(Duration(hours: 2));
    DateTime nowDate = DateTime(now.year, now.month, now.day);
    int nowDateTimeMinus12 = now.hour - 12;

    if(feedDate.isBefore(nowDate)) {
      light = false;
    } else if(feedDateTimeMinus12 * nowDateTimeMinus12 > 0) {
      light = true;
    } else {
      light = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.green,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
        widget.onToggle(value); // Call the callback  
      },
    );
  }
}
