import 'dart:math';

import 'package:devapp/models/item_value.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdialogs/kdialogs.dart';

String generateRandomString() {
  const characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  String result = '';

  for (int i = 0; i < 7; i++) {
    result += characters[random.nextInt(characters.length)];
  }

  return result;
}

Future<ItemValue?> showItemValueFormDialog(BuildContext context, {ItemValue? item}) async {
  final formKey = GlobalKey<FormState>();
  String id = item?.id ?? generateRandomString();
  String name = item?.name ?? "";
  String description = item?.description ?? "";
  String itemValue = item?.value ?? "";
  bool state = item?.state ?? false;

  return await showKDialogContent<ItemValue>(
    context,
    title: "Variable Item",
    saveBtnText: "Save",
    onSave: () {
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;
      formKey.currentState?.save();
      context.pop(ItemValue(
        id: id,
        name: name,
        description: description,
        value: itemValue,
        state: state,
      ));
    },
    closeOnOutsideTab: false,
    builder: (context) {
      return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: description,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(label: Text("Description")),
              onSaved: (value) => description = value?.trim() ?? "",
            ),
            TextFormField(
              initialValue: name,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(label: Text("Identifier")),
              validator: ((value) => value?.trim().isEmpty ?? false ? 'Please enter a name' : null),
              onSaved: (value) => name = value?.trim() ?? "",
            ),
            TextFormField(
              initialValue: itemValue,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(label: Text("Value")),
              validator: ((value) => value?.trim().isEmpty ?? false ? 'Please set a value' : null),
              onSaved: (value) => itemValue = value?.trim() ?? "",
            ),
            const SizedBox(height: 12.0)
          ],
        ),
      );
    },
  );
}
