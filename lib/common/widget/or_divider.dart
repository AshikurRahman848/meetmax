import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(children: const [
      Expanded(child: Divider()), SizedBox(width: 12),
      Text('OR'), SizedBox(width: 12),
      Expanded(child: Divider()),
    ]);
  }
}
