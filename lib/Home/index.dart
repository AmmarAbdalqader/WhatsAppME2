import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController numberCon = TextEditingController();

  CountryCode? country;

  String? num;

  bool darkMode = true;

  Widget countryDropDown() {
    return Expanded(
      child: CountryCodePicker(
        onChanged: (CountryCode x) {
          setState(() {
            country = x;
          });
        },
        initialSelection: 'الأردن',
        favorite: ['+962', 'الأردن'],
        showDropDownButton: true,
        textStyle: TextStyle(color: darkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Widget numberField() {
    return Expanded(
      flex: 2,
      child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          label: Text("Phone Number"),
          suffixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal),
          ),
        ),
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
        cursorColor: Colors.teal,
        controller: numberCon,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
      onPressed: () async {
        if (numberCon.text.isNotEmpty &&
            (numberCon.text.length == 10 || numberCon.text.length == 9)) {
          num = numberCon.text.length == 10
              ? numberCon.text.toString().substring(1, 10)
              : numberCon.text.trim();

          print(num);
          print(country?.dialCode);

          Uri url = Uri.parse(
              "whatsapp://send?phone=${country?.dialCode.toString().split("+")[1]}" +
                  num!);

          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw "Could not launch $url";
          }
        } else {
          _showMyDialog();
        }
      },
      child: Text(
        "GO",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid number'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Input a valid number'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: AssetImage(
              darkMode ? "assets/black.jpg" : "assets/whatsappbackground.png"),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('To What\'s App'),
            centerTitle: true,
            backgroundColor: Colors.teal,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    darkMode = !darkMode;
                  });
                },
                icon: Icon(Icons.sunny),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  countryDropDown(),
                  numberField(),
                ],
              ),
              submitButton(),
            ],
          ),
        ),
      ],
    );
  }
}
