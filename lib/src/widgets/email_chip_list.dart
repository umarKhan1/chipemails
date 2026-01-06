import 'package:flutter/material.dart';
import '../chip_email_controller.dart';
import 'email_chip.dart';

/// A list of email chips with reordering support.
class EmailChipList extends StatelessWidget {
  final ChipEmailController controller;
  final bool useGlassEffect;
  final bool enableReordering;

  const EmailChipList({
    super.key,
    required this.controller,
    this.useGlassEffect = false,
    this.enableReordering = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: controller,
      builder: (context, emails, _) {
        if (emails.isEmpty) return const SizedBox.shrink();

        if (enableReordering) {
          return SizedBox(
            height: 60,
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: emails.length,
              onReorder: controller.reorder,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              proxyDecorator: (child, index, animation) {
                return Material(
                  color: Colors.transparent,
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                final email = emails[index];
                return Padding(
                  key: ValueKey(email),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: EmailChip(
                    email: email,
                    onDeleted: () => controller.removeEmail(email),
                    useGlassEffect: useGlassEffect,
                  ),
                );
              },
            ),
          );
        }

        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: emails.map((email) {
            return EmailChip(
              email: email,
              onDeleted: () => controller.removeEmail(email),
              useGlassEffect: useGlassEffect,
            );
          }).toList(),
        );
      },
    );
  }
}
