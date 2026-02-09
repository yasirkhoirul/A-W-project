import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorRetry extends StatelessWidget{
  final String message;
  final VoidCallback onRetry;
  const ErrorRetry({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(color:  Color(0xFFB00020)),),
          const SizedBox(height: 8,),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}