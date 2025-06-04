import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:talento_flutter/presentation/widgets/no_internet.dart';

class ConnectivityUtils {
  static final ConnectivityUtils _instance = ConnectivityUtils._internal();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  factory ConnectivityUtils() {
    return _instance;
  }

  ConnectivityUtils._internal();

  void init(BuildContext context) {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        showNoInternetWidget(context);
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  Future<bool> checkInternet() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static void showNoInternetWidget(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      pageBuilder: (context, animation, secondaryAnimation) {
        return NoInternetWidget(
          onRetry: () async {
            if (await ConnectivityUtils().checkInternet()) {
              Navigator.of(context).pop();
            }
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
          ),
          child: child,
        );
      },
    );
  }
}
