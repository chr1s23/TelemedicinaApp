import 'package:flutter/material.dart';

Future<void> modalYesNoDialog({required BuildContext context, required String title, required String message, 
  required void Function() onYes, void Function()? onNo}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(
          message,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text('Sí'),
            onPressed: () {
              onYes();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text('No'),
            onPressed: () {
              if (onNo != null) {
                onNo();
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget buildLabel(String text) {
  return Align(
    alignment: Alignment.topLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: const Color.fromRGBO(111, 111, 111, 1),
      ),
    ),
  );
}

Widget buildDropdown(List<String> items, String? selectedItem,
    ValueChanged<String?> onChanged, String hint, {bool requiredInput = false}) {
  return DropdownButtonFormField<String>(
    value: selectedItem,
    decoration: inputDecoration(hint),
    style: TextStyle(fontSize: 15, color: Colors.black),
    onChanged: onChanged,
    items: items.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    validator: (value) => value == null && requiredInput ? "Campo obligatorio" : null,
  );
}

InputDecoration inputDecoration(hint, {isCalendar = false}) {
  return InputDecoration(
    prefixIcon: isCalendar ? Icon(Icons.calendar_today) : null,
    hintText: hint, // Placeholder
    hintStyle: TextStyle(
        color: Color.fromRGBO(111, 111, 111, 1),
        fontSize: 13), // Estilo del placeholder
    errorStyle: TextStyle(fontSize: 12, color: Color.fromRGBO(165, 16, 8, 1)),
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
      borderRadius: BorderRadius.circular(30), // Borde redondeado opcional
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.5),
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromRGBO(111, 111, 111, 1), width: 1.0),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}