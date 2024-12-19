enum DynamicFormFieldTypes { TextField, TextArea, Button, OptionPicker }
enum DynamicFormFieldLabelPositions { None, Left, Top, Right }
class DynamicFormField {
  final String id;
  final String name;
  final bool enabled;
  final DynamicFormFieldTypes fieldType;
  final Map<String, dynamic> data;
  final String Function(dynamic item)? getItemDisplayTextFn;
  final DynamicFormFieldLabelPositions labelPosition;

  String get initTextValue {
    if (fieldType == DynamicFormFieldTypes.TextField || fieldType == DynamicFormFieldTypes.TextArea) {
      if (data.containsKey("initValue")) {
        return data['initValue'];
      }
    }
    return "";
  }

  bool get multiSelect {
    if (data.containsKey('multiSelect')) return data['multiSelect'];
    return false;
  }

  bool get isDropdown {
    if (data.containsKey('pickerType')) return data['pickerType'] == 'dropdown';
    return false;
  }

  bool get useFixedDataItems {
    if (fieldType == DynamicFormFieldTypes.OptionPicker) {
      if (data.containsKey("dataItems")) {
        return true;
      }
    }
    return false;
  }

  List<dynamic> get dataItems {
    if (fieldType == DynamicFormFieldTypes.OptionPicker) {
      if (data.containsKey("dataItems")) {
        return data['dataItems'];
      }
    }
    return [];
  }

  DynamicFormField({required this.id, required this.name, required this.fieldType, this.enabled = true, this.data = const {}, this.getItemDisplayTextFn = null, this.labelPosition = DynamicFormFieldLabelPositions.Top});

  int get minLines {
    if (fieldType == DynamicFormFieldTypes.TextArea) {
      if (data.containsKey("minLines")) return data['minLines'];
    }
    return 1;
  }
  int get maxLines {
    if (fieldType == DynamicFormFieldTypes.TextArea) {
      if (data.containsKey("maxLines")) return data['maxLines'];
    }
    return 3;
  }



  static DynamicFormField createDropdownSelect(String id, String name, {bool enabled = true, bool multiSelect = false, List<dynamic>? items}) {
    Map<String, dynamic> data = { 'pickerType': 'dropdown', 'multiSelect': multiSelect };
    if (items != null) data['dataItems'] = items;
    return DynamicFormField(id: id, name: name, fieldType: DynamicFormFieldTypes.OptionPicker, enabled: enabled, data: data);
  }

  static DynamicFormField createOptionGroup(String id, String name, {bool enabled = true, bool multiSelect = false, List<dynamic>? items}) {
    Map<String, dynamic> data = { 'pickerType': 'radio', 'multiSelect': multiSelect };
    if (items != null) data['dataItems'] = items;
    return DynamicFormField(id: id, name: name, fieldType: DynamicFormFieldTypes.OptionPicker, enabled: enabled, data: data);
  }

  String getItemDisplayText(x) {
    if (getItemDisplayTextFn != null) return getItemDisplayTextFn!(x);
    return "$x";
  }
}
