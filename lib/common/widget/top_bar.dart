import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, this.language = 'English (UK)', this.onLanguageTap});

  final String language;
  final VoidCallback? onLanguageTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/logo.png', height: 25, fit: BoxFit.contain),
            const SizedBox(width: 8),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: onLanguageTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: Row(
              children: [
                Text(language, style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
