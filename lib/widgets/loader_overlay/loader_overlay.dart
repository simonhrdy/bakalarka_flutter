import 'package:flutter/material.dart';

class LoaderOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withAlpha(125),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
