import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsappme2/Helpers/Device.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController numberCon = TextEditingController();

  CountryCode? country;

  String? num;

  Widget countryDropDown() {
    return Expanded(
      child: CountryCodePicker(
        onChanged: (CountryCode x) {
          setState(() {
            country = x;
          });
        },
        initialSelection: 'الأردن',
        favorite: ['+962', 'الأردن', '+1', 'USA'],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
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
          suffixIconColor: Colors.teal,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal),
          ),
        ),
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
          primary: Colors.teal,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10)),
      onPressed: () async {
        if (numberCon.text.isNotEmpty && numberCon.text.length == 10) {
          num = numberCon.text.trim();
          print("whatsapp://send?phone=${country.toString().split("+")[1]}" +
              numberCon.text);
          Uri url = Uri.parse(
              "whatsapp://send?phone=${country.toString().split("+")[1]}" +
                  numberCon.text);
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
                Text('Input a Valid number'),
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
    Device.width = MediaQuery.of(context).size.width;
    Device.height = MediaQuery.of(context).size.height;
    Device.isPhone = MediaQuery.of(context).size.shortestSide < 600;
    return Stack(
      children: [
        Image(
          image: AssetImage("assets/whatsappbackground.png"),
          height: Device.height,
          width: Device.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('To What\'s App'),
            centerTitle: true,
            backgroundColor: Colors.teal,
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
