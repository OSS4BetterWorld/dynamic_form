import 'package:dynamic_form/form_controller.dart';
import 'package:flutter/material.dart';

class DynamicForm extends StatefulWidget {
  const DynamicForm({super.key, required this.controller});
  final DynamicFormController controller;
  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.bindState(reloadForm: () {
      setState(() {      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return widget.controller.buildForm(context);
  }
}
