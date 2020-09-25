import 'dart:convert';

import 'package:dns_registration/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:dns_registration/objects/contacts.dart' as _contacts;

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class InputDataPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // final Contacts _contacts = new Contacts();

  @override
  Widget build(BuildContext context) {
    Widget _input(String hint, TextEditingController controller,
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

    Widget _button(String label, void func()) {
      return RaisedButton(
        color: Colors.yellow[800],
        child: Text(label),
        textColor: Colors.white,
        onPressed: () {
          func();
        },
      );
    }

    Widget _showForm(String label, void func()) {
      return Container(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: _input('Имя', _firstNameController, TextInputType.name),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: _input('Фамилия', _lastNameController, TextInputType.name),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: _input(
                  'e-mail', _emailController, TextInputType.emailAddress),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: _input('Телефон', _phoneController, TextInputType.phone),
            ),
            SizedBox(
              height: 150,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: _button(label, func),
              ),
            ),
          ],
        ),
      );
    }

    void _returnKey() async {
      _contacts.firstName = _firstNameController.text;
      _contacts.lastName = _lastNameController.text;
      _contacts.phone = _phoneController.text;
      _contacts.email = _emailController.text;

      if ((_contacts.firstName.length > 0) &&
          (_contacts.lastName.length > 0) &&
          (_contacts.email.length > 0) &&
          (_contacts.phone.length > 0)) {
        var response = await http.post(
          'https://vacancy.dns-shop.ru/api/candidate/token',
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            "firstName": _contacts.firstName,
            "lastName": _contacts.lastName,
            "phone": _contacts.phone,
            "email": _contacts.email
          }),
        );

        if (response.statusCode == 200) {
          print("Response body: ${response.body}");
          var parsedJson = json.decode(response.body);

          if (parsedJson['message'].toString().length == 0){
            _contacts.token = parsedJson['data'];
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegistrationPage()));
          }
          else {
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

          _firstNameController.clear();
          _lastNameController.clear();
          _emailController.clear();
          _phoneController.clear();
        }
      }

      // print("${_contacts.email}");
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Ввод данных'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Container(
        child: _showForm('ПОЛУЧИТЬ КЛЮЧ', _returnKey),
      ),
    );
  }

}
