import 'package:flutter/material.dart';

class QuestionOptionCard extends StatelessWidget {
  final String title;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final bool isSelected;

  const QuestionOptionCard({
    super.key,
    required this.title,
    required this.groupValue,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: RadioListTile<String>(
        title: Text(title),
        value: title,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
