import 'dart:convert';

import 'package:oss4bt_dynamic_form/field.dart';
import 'package:oss4bt_dynamic_form/form_controller.dart';
import 'package:oss4bt_dynamic_form/form_creation.dart';
import 'package:flutter/material.dart';


class NewProjectDFController extends DynamicFormController {
  NewProjectDFController() {
    formCreation = DynamicFormCreation(fields: [
      DynamicFormField(id: 'name',
          name: 'Project Name',
          fieldType: DynamicFormFieldTypes.TextField),
      DynamicFormField(id: 'desc',
          name: 'Project Description',
          fieldType: DynamicFormFieldTypes.TextArea),
      DynamicFormField.createDropdownSelect('category', 'Category', items: [
        'Application Builder',
        'Story Builder',
        'Course Builder',
        'Marketing Campaign Builder'
      ])
    ]);
  }

}

class ProjectListingScreen extends StatefulWidget {
  const ProjectListingScreen({super.key});

  @override
  State<ProjectListingScreen> createState() => _ProjectListingScreenState();
}

class _ProjectListingScreenState extends State<ProjectListingScreen> {
  NewProjectDFController newProjectFormController = NewProjectDFController();

  @override
  void initState() {
    super.initState();
    newProjectFormController.bindState(reloadForm: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> projectWidgets = [];
    return Scaffold(
      appBar: AppBar(title: Text("GenAI Projects"), actions: [
        IconButton(onPressed: ( ) => showAddNewProjectDialog(), icon: Icon(Icons.add))
      ]),
      body: SafeArea(child: ListView(children: projectWidgets)),
    );
  }

  showAddNewProjectDialog() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Create new Project"),
      content: newProjectFormController.buildForm(context),
      actions: [ElevatedButton(onPressed: () {
        bool isValid = newProjectFormController.validateFields();
        if (isValid) {
          Navigator.pop(context);
          var model = newProjectFormController.formValues;
          debugPrint("New Project Model:");
          debugPrint(jsonEncode(model));
        }
    }, child: Text("Create"))
      ],
    ));
  }
}
