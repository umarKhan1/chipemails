import 'dart:ui';
import 'package:flutter/material.dart';

/// A modern, customizable email chip.
/// Includes support for domain-based branding, avatars, and glassmorphism.
class EmailChip extends StatelessWidget {
  final String email;
  final VoidCallback onDeleted;
  final bool useGlassEffect;
  final Color? baseColor;

  const EmailChip({
    super.key,
    required this.email,
    required this.onDeleted,
    this.useGlassEffect = false,
    this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    final domainColor = baseColor ?? _getColorForDomain(email);

    Widget chip = Chip(
      avatar: CircleAvatar(
        backgroundColor: domainColor.withValues(alpha: 0.2),
        child: Text(
          email[0].toUpperCase(),
          style: TextStyle(
              color: domainColor, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      label: Text(
        email,
        style: TextStyle(
          color: useGlassEffect ? Colors.white : domainColor.withAlpha(200),
          fontWeight: FontWeight.w500,
        ),
      ),
      onDeleted: onDeleted,
      deleteIconColor: useGlassEffect ? Colors.white70 : domainColor,
      backgroundColor: useGlassEffect
          ? Colors.white.withValues(alpha: 0.1)
          : domainColor.withValues(alpha: 0.1),
      side: BorderSide(
        color: useGlassEffect
            ? Colors.white.withValues(alpha: 0.2)
            : domainColor.withValues(alpha: 0.3),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    if (useGlassEffect) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: chip,
        ),
      );
    }

    return chip;
  }

  /// Generates a consistent color based on the email domain.
  /// This implements the "Domain-Specific Styling" feature.
  Color _getColorForDomain(String email) {
    final parts = email.split('@');
    if (parts.length < 2) return Colors.blueGrey;

    final domain = parts[1].toLowerCase();

    // Some hardcoded presets for popular domains
    if (domain.contains('gmail.com')) {
      return Colors.redAccent;
    }
    if (domain.contains('outlook.com') || domain.contains('microsoft.com')) {
      return Colors.blueAccent;
    }
    if (domain.contains('yahoo.com')) {
      return Colors.deepPurpleAccent;
    }
    if (domain.contains('apple.com') || domain.contains('icloud.com')) {
      return Colors.grey;
    }

    // Fallback: Generate color from hash of domain
    final hash = domain.hashCode;
    return HSLColor.fromAHSL(1.0, (hash % 360).toDouble(), 0.65, 0.5).toColor();
  }
}
