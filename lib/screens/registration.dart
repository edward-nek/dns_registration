import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dns_registration/objects/contacts.dart' as _contacts;
import 'inputData.dart';

import 'package:http/http.dart' as http;
import 'package:dns_registration/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController _gitController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();

  // final FullContacts _fullContacts = new FullContacts();

  @override
  Widget build(BuildContext context) {
    Widget _inputReg(String hint, TextEditingController controller,
        TextInputType typeInput) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: new TextFormField(
          controller: controller,
          maxLines: 1,
          keyboardType: typeInput,
          autofocus: false,
          decoration: new InputDecoration(
            hintText: hint,
          ),
        ),
      );
    }

    Widget _buttonReg(String label, void func()) {
      return RaisedButton(
        color: Colors.yellow[800],
        child: Text(label),
        textColor: Colors.white,
        onPressed: () {
          func();
        },
      );
    }

    Widget _showFormReg(String label, void func()) {
      return Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: _inputReg(
                  'ссылка на github', _gitController, TextInputType.text),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: _inputReg(
                  'ссылка на резюме', _resumeController, TextInputType.text),
            ),
            SizedBox(
              height: 300,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: _buttonReg(label, func),
              ),
            ),
          ],
        ),
      );
    }

    void _returnKey() async {
      _contacts.git = _gitController.text;
      _contacts.resume = _resumeController.text;

      if ((_contacts.git.length > 0) && (_contacts.resume.length > 0)) {
        var response = await http.post(
          'https://vacancy.dns-shop.ru/api/candidate/summary',
          headers: <String, String>{
            'Authorization': 'Bearer ${_contacts.token}',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            "firstName": _contacts.firstName,
            "lastName": _contacts.lastName,
            "phone": _contacts.phone,
            "email": _contacts.email,
            "githubProfileUrl": _contacts.git,
            "summary": _contacts.resume,
          }),
        );

        print("Response body: ${response.body}");
        if (response.statusCode == 200) {
          var parsedJson = json.decode(response.body);

          if (parsedJson['message'].toString().length == 0) {
            print("${parsedJson['data']}");
            Fluttertoast.showToast(
              msg: "${parsedJson['data']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          } else {
            print('${parsedJson['message']}');
            Fluttertoast.showToast(
              msg: "${parsedJson['message']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          }
        } else {
          print("Error  ${response.statusCode}");
          Fluttertoast.showToast(
            msg: "Error  ${response.statusCode}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0,
          );
          _gitController.clear();
          _resumeController.clear();
        }
      }

      // print('${_contacts.git} - ${_contacts.resume} - ${_contacts.token}');
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Регистрация'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Container(
        child: _showFormReg('ЗАРЕГИСТРИРОВАТЬСЯ', _returnKey),
      ),
    );
  }
}
