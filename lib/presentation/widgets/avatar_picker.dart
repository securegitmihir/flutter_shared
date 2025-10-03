import 'dart:io';
import 'package:assisted_living/services/app_colors.dart';
import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    super.key,
    required this.radius,
    required this.onTap,
    this.file,
    this.placeholderIcon = Icons.person,
    this.badgeColor,
  });

  final double radius;
  final VoidCallback onTap;
  final File? file;
  final IconData placeholderIcon;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final bc = badgeColor ?? Theme.of(context).colorScheme.primary;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFFE6ECE9),
            backgroundImage: file != null ? FileImage(file!) : null,
            child: file == null
                ? Icon(placeholderIcon, size: radius * 2.0, color: AppColors.btnTextColor)
                : null,
          ),
        ),
        Positioned(
          right: -2,
          bottom: 10,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bc,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6)
                // border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.camera_alt_outlined, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}


