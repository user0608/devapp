import 'package:devapp/models/item_value.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kdialogs/kdialogs.dart';

Future<ItemValue?> showItemValueFormDialog(BuildContext context, {ItemValue? item}) async {
  final formKey = GlobalKey<FormState>();
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
              initialValue: name,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(label: Text("Identifier")),
              validator: ((value) => value?.trim().isEmpty ?? false ? 'Please enter a name' : null),
              onSaved: (value) => name = value?.trim() ?? "",
            ),
            TextFormField(
              initialValue: description,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(label: Text("Description")),
              onSaved: (value) => description = value?.trim() ?? "",
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
