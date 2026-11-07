import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/gardirop_bottom_nav.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    if (location.startsWith('/closet')) {
      return 1;
    }

    if (location.startsWith('/stylist')) {
      return 2;
    }

    if (location.startsWith('/style')) {
      return 3;
    }

    if (location.startsWith('/you')) {
      return 4;
    }

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;

      case 1:
        context.go('/closet');
        break;

      case 2:
      // Gardi / Stylist route later
        break;

      case 3:
        context.go('/style');
        break;

      case 4:
      // You route later
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: GardiropBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }
}