import 'package:flutter/material.dart';

enum EIStatusEditField {
  fieldNeedCheck,
  fieldChecked,
  fieldNormal,
  fieldWrong,
}

class WidgetFormFieldDefault extends StatelessWidget {
  Key keyName;
  FormFieldValidator<String>? validator;
  String text;
  EIStatusEditField? status;
  TextEditingController? controller;
  bool? enabled;
  String? initialValue;

  WidgetFormFieldDefault({
    Key? key,
    this.controller,
    this.initialValue,
    required this.keyName,
    required this.validator,
    required this.text,
    this.status,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _edit(
        context: context,
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          initialValue: initialValue,
          decoration: _decoration(
              context: context,
              text: text,
              status: status ?? EIStatusEditField.fieldNormal),
          key: keyName,
          validator: validator,
        ));
  }

  _edit({required BuildContext context, required Widget child}) {
    return Container(
        height: 60.0,
        padding: const EdgeInsets.only(left: 20, top: 8),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20.0,
              offset: Offset(0, 10.0),
            ),
          ],
        ),
        child: child);
  }

  _decoration(
      {required BuildContext context,
      required String text,
      required EIStatusEditField status}) {
    Icon _icon = Icon(
      Icons.check,
      color: Theme.of(context).colorScheme.onBackground,
      size: 20.0,
    );

    if (status == EIStatusEditField.fieldChecked) {
      _icon = Icon(
        Icons.check_circle_rounded,
        color: Theme.of(context).colorScheme.primary.withAlpha(80),
        size: 20.0,
      );
    } else if (status == EIStatusEditField.fieldNeedCheck) {
      _icon = Icon(
        Icons.check,
        color: Theme.of(context).colorScheme.onBackground,
        size: 20.0,
      );
    } else if (status == EIStatusEditField.fieldWrong) {
      _icon = const Icon(
        Icons.close,
        color: Colors.red,
        size: 20.0,
      );
    }

    return InputDecoration(
      suffixIcon: _icon,
      border: InputBorder.none,
      hintText: text,
    );
  }
}
