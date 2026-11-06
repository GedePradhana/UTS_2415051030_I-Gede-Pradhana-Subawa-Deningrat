import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/refresh.dart';

/// SingleChildScrollView yang bisa ditarik ke bawah untuk memuat ulang data.
class RefreshableScroll extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const RefreshableScroll({super.key, this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => refreshAll(context),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// ListView yang bisa ditarik ke bawah untuk memuat ulang data.
class RefreshableListView extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;

  const RefreshableListView({super.key, this.padding, required this.children});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => refreshAll(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        children: children,
      ),
    );
  }
}