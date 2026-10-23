import 'package:flutter/material.dart';

import '../core/constants/color/app_colors.dart';

/// Common scaffold: optional app bar, background image and a full-screen
/// loader overlay that blocks input while [isLoading] is true.
class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.showAppBar = true,
    this.isLoading = false,
    this.backgroundImage,
    this.backgroundColor = AppColors.background,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool showAppBar;
  final bool isLoading;

  /// Asset path, e.g. an `ImageConstants` value.
  final String? backgroundImage;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: backgroundColor,
          appBar: showAppBar
              ? AppBar(
                  title: title == null ? null : Text(title!),
                  actions: actions,
                )
              : null,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
          body: DecoratedBox(
            decoration: BoxDecoration(
              image: backgroundImage == null
                  ? null
                  : DecorationImage(
                      image: AssetImage(backgroundImage!),
                      fit: BoxFit.cover,
                    ),
            ),
            child: SafeArea(child: body),
          ),
        ),
        if (isLoading)
          const Positioned.fill(
            child: ModalBarrier(dismissible: false, color: AppColors.overlay),
          ),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
