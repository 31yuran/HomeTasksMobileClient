import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:home_task/fetch_data/related_user.dart';

class TextFieldValue {
  String value = "Not set";
}

TextFormField createTextField(Function changeHandler, String labelText,
    String hintText, TextFieldValue textValue) {
  return new TextFormField(
    decoration: InputDecoration(labelText: labelText, hintText: hintText),
    validator: (value) {
      if (value.isEmpty) {
        return 'Please enter a name';
      }
    },
    onChanged: (value) {
      changeHandler(value);
    },
  );
}

RaisedButton createDateTimeButton(
    Function changeHandler, BuildContext context, TextFieldValue textValue,
    {bool isDate}) {
  return new RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      onPressed: () {
        var func =
            isDate ? DatePicker.showDatePicker : DatePicker.showDateTimePicker;
        func(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (dateTime) {
          textValue.value = '${dateTime.day}.${dateTime.month}.${dateTime.year}'
              '  '
              '${dateTime.hour}:${dateTime.minute}';
          changeHandler();
        }, currentTime: DateTime.now(), locale: LocaleType.ru);
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.date_range,
                        size: 18.0,
                        color: Colors.teal,
                      ),
                      Text(
                        " ${textValue.value}",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ],
        ),
      ));
}

DateTime parseToDateTime(String str) {
  String year, month, day, hours, minutes;
  var parts = str.split(' ').where((x) => x.isNotEmpty).toList();
  if (parts.length == 2) {
    var dateParts = parts[0].split('.');
    if (dateParts.length == 3) {
      day = dateParts[0];
      month = dateParts[1];
      year = dateParts[2];
    }
    var timeParts = parts[1].split(':');
    if (timeParts.length == 2) {
      hours = timeParts[0];
      minutes = timeParts[1];
    }
  }
  if (year == null ||
      month == null ||
      day == null ||
      hours == null ||
      minutes == null) return null;
  return new DateTime(int.parse(year), int.parse(month), int.parse(day),
      int.parse(hours), int.parse(minutes));
}

DateTime parseToDateTimeFromApi(String str) {
  String year, month, day, hours, minutes;
  var parts = str.split('-').where((x) => x.isNotEmpty).toList();
  if (parts.length == 3) {
    year = parts[0];
    month = parts[1];
    var dayTimeParts = parts[2].split('T').where((x) => x.isNotEmpty).toList();
    if (dayTimeParts.length == 2) {
      day = dayTimeParts[0];
      var timeParts = dayTimeParts[1].split(':');
      if (timeParts.length >= 2) {
        hours = timeParts[0];
        minutes = timeParts[1];
      }
    }
  }
  if (year == null ||
      month == null ||
      day == null ||
      hours == null ||
      minutes == null) return null;
  return new DateTime(int.parse(year), int.parse(month), int.parse(day),
      int.parse(hours), int.parse(minutes));
}

List<DropdownMenuItem<String>> createSlavesDropDownItems(
    List<RelatedUser> slaves) {
  var ddItems = new List<DropdownMenuItem<String>>();
  for (var i = 0; i < slaves.length; i++) {
    ddItems.add(new DropdownMenuItem(
        child: Text(slaves[i].name), value: slaves[i].name));
  }
  return ddItems;
}
