import 'package:flutter/cupertino.dart';
import 'package:talento_flutter/core/utils/globals.dart';
import 'package:talento_flutter/presentation/widgets/helper.dart';

class TimeTracker extends StatefulWidget {
  final Widget child;
  final String screenName;

  const TimeTracker({required this.screenName, required this.child, super.key});

  @override
  TimeTrackerState createState() => TimeTrackerState();
}

class TimeTrackerState extends State<TimeTracker> with RouteAware {
  late DateTime _startTime;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _startTime = DateTime.now();
  }

  @override
  void didPop() {
    _recordTimeSpent();
  }

  @override
  void didPopNext() {
    // When user returns to this screen
    _startTime = DateTime.now();
  }

  @override
  void didPushNext() {
    // When user navigates away from this screen
    _recordTimeSpent();
  }

  void _recordTimeSpent() {
    final duration = DateTime.now().difference(_startTime);
    printInDebugMode(
      "User spent ${duration.inSeconds}s on ${widget.screenName}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
