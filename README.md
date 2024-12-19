# Dynamic Form
A simple StatefulWidget Form with dynamic content

## Features
- Support TextField, TextArea, OptionPicker ( multiple/single select, Dropdown or Radio )

## Getting started
- This is in early state library, so it will usually have breaking changes in next version
## Usage

### 1. First, create a Controller extends DynamicFormController and design the Form in Controller constructor
```dart
class NewProjectDFController extends DynamicFormController {
  NewProjectDFController() {
    // 
    // design the form
    //
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
```

### 2. Then, declare an instance of Controller and bind state in initState()
```dart
// declare the Controller
NewProjectDFController newProjectFormController = NewProjectDFController();

// bind state
@override
void initState() {
  super.initState();
  newProjectFormController.bindState(reloadForm: () => setState(() {}));
}
```

### 3. use it as Dialog content or as other Widget in build()
```dart
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
```
