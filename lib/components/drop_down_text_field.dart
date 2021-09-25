import 'package:flutter/material.dart';

class DropDownTextField extends StatefulWidget {
  const DropDownTextField({Key? key, required this.categories, required this.onChanged, required this.hint})
      : super(key: key);

  final List<String> categories;
  final void Function(String?) onChanged;
  final String hint;

  @override
  _DropDownTextFieldState createState() => _DropDownTextFieldState();
}

class _DropDownTextFieldState extends State<DropDownTextField> {
  String? _category;

  @override
  Widget build(BuildContext context) {
    if (_category != null) {
      if (widget.categories.contains(_category) == false) {
        _category = null;
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: DropdownButtonFormField(
          isExpanded: true,
          items: widget.categories.map((String category) {
            return new DropdownMenuItem(
              value: category,
              child: Text(
                category,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontSize: 18),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _category = newValue as String?;
              widget.onChanged(_category);
            });
          },
          value: _category,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(borderSide: BorderSide(width: 2), borderRadius: BorderRadius.circular(5)),
              filled: true,
              fillColor: Colors.grey[200],
              hintText: widget.hint,
              hintStyle: TextStyle(fontSize: 18))),
    );
  }
}
