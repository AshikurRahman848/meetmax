import 'package:flutter/material.dart';

enum Gender { male, female }

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key, required this.value, required this.onChanged});
  final Gender value;
  final ValueChanged<Gender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: RadioListTile<Gender>(value: Gender.male,   groupValue: value, onChanged: (g){ if(g!=null) onChanged(g); }, title: const Text('Male'))),
      const SizedBox(width: 8),
      Expanded(child: RadioListTile<Gender>(value: Gender.female, groupValue: value, onChanged: (g){ if(g!=null) onChanged(g); }, title: const Text('Female'))),
    ]);
  }
}
