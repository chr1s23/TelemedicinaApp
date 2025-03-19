import 'package:flutter/material.dart';

sealed class AllowedColors {
  static const Color red = Color.fromRGBO(165, 16, 8, 1);
  static const Color blue = Color.fromRGBO(0, 40, 86, 1);
  static const Color gray = Color.fromRGBO(111, 111, 111, 1);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
}

void Function() modalLoadingDialog({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator(value: null))
  );

  return Navigator.of(context).pop;
}

Future<void> modalYesNoDialog({required BuildContext context, required String title, required String message, 
  required void Function() onYes, void Function()? onNo}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
        color: AllowedColors.gray,
      ),
    ),
  );
}

Widget buildDropdown(List<String> items, String? selectedItem,
    ValueChanged<String?> onChanged, String hint, {bool requiredInput = false}) {
  return DropdownButtonFormField<String>(
    value: selectedItem,
    decoration: inputDecoration(hint),
    style: TextStyle(fontSize: 15, color: AllowedColors.black),
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
        color: AllowedColors.gray,
        fontSize: 13), // Estilo del placeholder
    errorStyle: TextStyle(fontSize: 12, color: AllowedColors.red),
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: AllowedColors.gray, width: 1.0),
      borderRadius: BorderRadius.circular(30), // Borde redondeado opcional
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: AllowedColors.gray, width: 1.5),
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: AllowedColors.gray, width: 1.0),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}

// For testing purposes
Future<void> delay(Duration duration) {
  return Future.delayed(duration);
}