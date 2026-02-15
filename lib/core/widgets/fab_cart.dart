import 'package:flutter/material.dart';

class FabCart extends StatelessWidget {
  final VoidCallback onPressed;
  final int itemCount;

  const FabCart({
    super.key,
    required this.onPressed,
    this.itemCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          shape: const CircleBorder(),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
        if (itemCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              child: Text(
                itemCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
