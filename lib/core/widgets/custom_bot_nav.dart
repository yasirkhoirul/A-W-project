import 'dart:ui';

import 'package:a_and_w/core/entities/nav_item.dart';
import 'package:flutter/material.dart';

class CustomBotNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<NavItem> items;

  const CustomBotNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(230),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: colorScheme.primary.withAlpha(50),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                items.length,
                (index) => _NavBarItem(
                  item: items[index],
                  isSelected: selectedIndex == index,
                  onTap: () => onTap(index),
                  colorScheme: colorScheme,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isSelected ? 3 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.onPrimary.withAlpha(51)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onPrimary.withAlpha(77),
                child: Icon(
                  item.icon,
                  color: isSelected ? colorScheme.primary : colorScheme.onPrimary,
                  size: 22,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 12),
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

