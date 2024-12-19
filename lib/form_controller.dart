import 'dart:ui';

import 'package:oss4bw_dynamic_form/field.dart';
import 'package:oss4bw_dynamic_form/form_creation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class PickerController {
  List<int> indices = [0];
}

class DynamicFormController {
  late DynamicFormCreation formCreation;
  late VoidCallback doReloadForm;
  var controllerMap = {};
  Widget buildForm(BuildContext context) {
    List<Widget> fieldControls = [];
    for (var f in formCreation.fields) {
      fieldControls.add(buildField(context, f));
    }
    return Container(child: Column(children: fieldControls));
  }

  void bindState({required VoidCallback reloadForm}) {
    doReloadForm = reloadForm;
  }

  bool validateFields() {
    return false;
  }

  Widget buildField(BuildContext context, DynamicFormField f) {
    if (f.fieldType == DynamicFormFieldTypes.TextField)
      return buildTextField(context, f);
    if (f.fieldType == DynamicFormFieldTypes.TextArea)
      return buildTextArea(context, f);
    if (f.fieldType == DynamicFormFieldTypes.OptionPicker) {
      if (f.isDropdown)
        return buildDropdown(context, f);
      else
        return buildRadioGroup(context, f);
    }
    return Text("Not support Field Type: ${f.fieldType}");
  }

  Widget buildTextField(BuildContext context, DynamicFormField f) {
    late TextEditingController controller;
    if (!controllerMap.containsKey(f.id)) {
      controller = TextEditingController();
      controllerMap[f.id] = controller;
      controller.text = f.initTextValue;
    } else {
      controller = controllerMap[f.id];
    }

    return TextFormField(controller: controller,
    decoration: InputDecoration(
      label: Text(f.name)
    ),
    );
  }

  Widget buildTextArea(BuildContext context, DynamicFormField f) {
    late TextEditingController controller;
    if (!controllerMap.containsKey(f.id)) {
      controller = TextEditingController();
      controllerMap[f.id] = controller;
      controller.text = f.initTextValue;
    } else {
      controller = controllerMap[f.id];
    }
    return TextFormField(
        controller: controller, minLines: f.minLines, maxLines: f.maxLines,
      decoration: InputDecoration(
        label: Text(f.name)
      ),
    );
  }

  Widget buildDropdown(BuildContext context, DynamicFormField f) {
    PickerController controller = PickerController();
    if (controllerMap.containsKey(f.id)) controller = controllerMap[f.id];
    else {
      controllerMap[f.id] = controller;
      controller.indices = [0];
    }

    List<DropdownMenuItem<int>> items = [];
    List<dynamic> dataItems = getPickerDataItems(context, f);
    for(int i = 0; i < dataItems.length; i++) {
      var x = dataItems[i];
      items.add(DropdownMenuItem(child: Text(f.getItemDisplayText(x)), value: i));
    }

    var dd = DropdownButton<int>(
      isExpanded: true,
        items: items,
        value: controller.indices[0],
        onChanged: (index) {
          controller.indices = [index!];
          doReloadForm();
        });

    if (f.labelPosition == DynamicFormFieldLabelPositions.Left) {
      return Row(children: [Text(f.name), dd]);
    }
    else if (f.labelPosition == DynamicFormFieldLabelPositions.Right) {
      return Row(children: [dd, Text(f.name)]);
    }
    else if (f.labelPosition == DynamicFormFieldLabelPositions.Top) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
          children: [Text(f.name), dd]);
    }
    return dd;
  }

  Widget buildRadioGroup(BuildContext context, DynamicFormField f) {
    PickerController controller = PickerController();
    if (controllerMap.containsKey(f.id)) controller = controllerMap[f.id];
    else {
      controllerMap[f.id] = controller;
      controller.indices = [0];
    }
    List<Widget> items = [
      Text(f.name)
    ];
    List<dynamic> dataItems = getPickerDataItems(context, f);
    for (int i = 0; i < dataItems.length; i++) {
      var x = dataItems[i];
      items.add(ListTile(
        title: Text(f.getItemDisplayText(x)),
        leading: Radio<int>(
          value: i,
          groupValue: controller.indices[0],
          onChanged: (index) {
            controller.indices = [index!];
            doReloadForm();
          },
        ),
      ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: items);
  }

  List<dynamic> getPickerDataItems(BuildContext context, DynamicFormField f) {
    if (f.useFixedDataItems) return f.dataItems;
    return getDynamicDataItemsForPicker(context, f);
  }

  //TODO: implement on sub class to provide custom, dynamic data
  List<dynamic> getDynamicDataItemsForPicker(
      BuildContext context, DynamicFormField f) {
    return [];
  }

  dynamic getFieldValue(DynamicFormField f) {
    if (f.fieldType == DynamicFormFieldTypes.TextArea || f.fieldType == DynamicFormFieldTypes.TextField) {
      return (controllerMap[f.id] as TextEditingController).text;
    }
    if (f.fieldType == DynamicFormFieldTypes.OptionPicker) {
      if (!f.multiSelect) {
        return (controllerMap[f.id] as PickerController).indices[0];
      }
      return (controllerMap[f.id] as PickerController).indices;
    }
  }

  Map<String, dynamic> get formValues {
    Map<String, dynamic> m = {};
    for(var f in formCreation.fields) {
      m[f.id] = getFieldValue(f);
    }
    return m;
  }
}
