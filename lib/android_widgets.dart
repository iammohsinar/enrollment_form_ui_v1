import 'package:flutter/material.dart';

import 'app_enum.dart';

enum gender { MALE, FEMALE }

class AndroidFormInputWidget extends StatelessWidget {
  const AndroidFormInputWidget(
      {Key? key,
      this.controller,
      required this.type,
      this.obscure = false,
      required this.hintText,
      required this.onChange,
      required this.intialValue,
      this.validator})
      : super(key: key);
  final TextEditingController? controller;
  final String hintText;
  final bool obscure;
  final dynamic intialValue;
  final FormInputType type;
  final void Function(dynamic newValue) onChange;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    print("AndroidFormInputWidget build");
    switch (this.type) {
      case FormInputType.TEXT:
        return TextFormField(
          validator: this.validator,
          controller: this.controller,
          obscureText: this.obscure,
          decoration: InputDecoration(
              hintText: this.hintText,
              fillColor: Colors.white,
              filled: true,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(color: Color(0xFFe28568), width: 1.0)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(color: Color(0xFFe28568), width: 1.0)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  borderSide: BorderSide(color: Color(0xFF6e4875), width: 1.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
                borderSide: BorderSide(color: Color(0xFF426d8e), width: 1.0),
                //border:
              )),
        );

      case FormInputType.SELECT:
        return DropdownButtonFormField<String>(
            style: const TextStyle(
              fontSize: 18.0,
              color: Color(0xFF6e4875),
            ),
            // underline: Container(
            //   height: 2,
            //   color: Color(0xFF6e4875),
            // ),
            icon: Icon(Icons.arrow_downward),
            iconEnabledColor: Color(0xFF426d8e),
            iconSize: 24.0,
            elevation: 16,
            onChanged: this.onChange,
            validator: this.validator,
            value: this.intialValue,
            items: <String>['Choose language', 'Java', 'Flutter', 'Python', 'Reactjs']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList());

      case FormInputType.RADIO:
        print('--> ${this.intialValue}');
        return Row(
          children: [
            Radio<gender>(
                value: gender.MALE, groupValue: this.intialValue, onChanged: this.onChange),
            Text(
              "Male",
              style: TextStyle(color: Color(0xFF6e4875), fontSize: 18.0),
            ),
            Radio<gender>(
                value: gender.FEMALE, groupValue: this.intialValue, onChanged: this.onChange),
            Text(
              "Female",
              style: TextStyle(color: Color(0xFF6e4875), fontSize: 18.0),
            ),
          ],
        );

      case FormInputType.CHECK_BOX:
        return Checkbox(value: this.intialValue, onChanged: this.onChange);
      case FormInputType.SWITCH:
        print(this.intialValue);
        return Switch(value: this.intialValue, onChanged: this.onChange);
    }
  }
}

class LoginAndroid extends StatefulWidget {
  const LoginAndroid(
      {Key? key, required this.login, required this.getEnrolled, required this.email})
      : super(key: key);
  final void Function(String email, String password) login;
  final void Function() getEnrolled;
  final String email;
  @override
  _LoginAndroidState createState() => _LoginAndroidState();
}

class _LoginAndroidState extends State<LoginAndroid> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // String dropDownValue = 'Choose language';
  // bool switchValue = false;
  // bool isChecked = false;
  // gender whoGender = gender.MALE;

  //var //isLogin = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AndroidFormInputWidget(
              controller: _emailController,
              type: FormInputType.TEXT,
              hintText: "email",
              onChange: (_) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your email address to continue';
                }
                return null;
              },
              intialValue: ''),
          SizedBox(
            height: 10.0,
          ),
          AndroidFormInputWidget(
              controller: _passwordController,
              obscure: true,
              type: FormInputType.TEXT,
              hintText: "password",
              onChange: (_) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter your passowrd';
                }
                return null;
              },
              intialValue: ""),
          SizedBox(height: 18.0),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(14.0),
                          primary: Color(0xFFe28568),
                          textStyle: TextStyle(fontSize: 20.0)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          widget.login(_emailController.text, _passwordController.text);
                        }
                        // setState(() {
                        //   //  this.//isLogin = !true;
                        // });
                      },
                      child: Text("Login"))),
            ],
          ),
          TextButton(
            onPressed: () {
              widget.getEnrolled();
            },
            child: Text(
              'Enroll your self',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
            style: TextButton.styleFrom(
                padding: EdgeInsets.all(14.0),
                primary: Color(0xFF6e4875),
                textStyle: TextStyle(
                  fontSize: 20.0,
                )),
          )
        ],
      ),
    );
  }
}

class RegisterAndroid extends StatefulWidget {
  const RegisterAndroid({Key? key, required this.register, required this.cancel})
      : super(key: key);
  final void Function(
      String name,
      String email,
      String password,
      gender gender,
      String idCard,
      int contactNum,
      String programmingLang,
      bool notifyForEvent,
      bool isParentAvailable,
      String parentRelationShip) register;
  final void Function() cancel;

  @override
  _RegisterAndroidState createState() => _RegisterAndroidState();
}

class _RegisterAndroidState extends State<RegisterAndroid> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idCardController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _parentRelationShipController = TextEditingController();

  String dropDownValue = 'Choose language';
  bool switchValue = false;
  bool isChecked = false;
  gender whoGender = gender.MALE;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            AndroidFormInputWidget(
              controller: _nameController,
              type: FormInputType.TEXT,
              hintText: "Your name",
              onChange: (_) {},
              intialValue: '',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter your name';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            AndroidFormInputWidget(
              controller: _emailController,
              type: FormInputType.TEXT,
              hintText: "Your email",
              onChange: (_) {},
              intialValue: '',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter your email';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            AndroidFormInputWidget(
              controller: _passwordController,
              obscure: true,
              type: FormInputType.TEXT,
              hintText: "Password",
              onChange: (_) {},
              intialValue: '',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter password';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            AndroidFormInputWidget(
              type: FormInputType.RADIO,
              hintText: "",
              onChange: (dynamic newValue) {
                print(newValue);
                setState(() {
                  this.whoGender = newValue;
                });
              },
              intialValue: this.whoGender,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please choose your gender';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            AndroidFormInputWidget(
              controller: _idCardController,
              type: FormInputType.TEXT,
              hintText: "Id card number",
              onChange: (_) {},
              intialValue: '',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter your id card';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            AndroidFormInputWidget(
              controller: _contactNumberController,
              type: FormInputType.TEXT,
              hintText: "Contact number",
              onChange: (_) {},
              intialValue: '',
              validator: (value) {
                if (value!.isEmpty) {
                  return 'please enter your number';
                }
                return null;
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: AndroidFormInputWidget(
                    type: FormInputType.SELECT,
                    hintText: "Your name",
                    onChange: (dynamic newValue) {
                      setState(() {
                        this.dropDownValue = newValue!;
                      });
                    },
                    intialValue: this.dropDownValue,
                    validator: (value) {
                      print("value ${value}");
                      if (value!.toLowerCase() == 'choose language') {
                        return 'please choose language';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Text(
                  "Notify me",
                  style: TextStyle(color: Color(0xFF6e4875), fontSize: 18.0),
                ),
                AndroidFormInputWidget(
                  type: FormInputType.SWITCH,
                  hintText: "",
                  onChange: (dynamic newValue) {
                    setState(() {
                      this.switchValue = newValue;
                    });
                  },
                  intialValue: this.switchValue,
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Are you going with parents?",
                      style: TextStyle(color: Color(0xFF6e4875), fontSize: 18.0),
                    ),
                    AndroidFormInputWidget(
                        type: FormInputType.CHECK_BOX,
                        hintText: "",
                        onChange: (dynamic newValue) {
                          print('AndroidFormInputWidget checkbox $newValue');
                          setState(() {
                            this.isChecked = newValue;
                          });
                        },
                        intialValue: this.isChecked)
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                if (this.isChecked)
                  AndroidFormInputWidget(
                    controller: _parentRelationShipController,
                    type: FormInputType.TEXT,
                    hintText: "e.g: father",
                    onChange: (_) {},
                    intialValue: '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please mention relationship of parents";
                      }
                      return null;
                    },
                  ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14.0),
                      primary: Color(0xFFe28568),
                      textStyle: TextStyle(fontSize: 20.0)),
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.register(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                          this.whoGender,
                          _idCardController.text,
                          int.parse(_contactNumberController.text),
                          this.dropDownValue,
                          this.switchValue,
                          this.isChecked,
                          _parentRelationShipController.text);
                    }
                    // setState(() {
                    //   //this.//isLogin = true;
                    // });
                  },
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(14.0),
                      primary: Color(0xFF426d8e),
                      textStyle: TextStyle(fontSize: 20.0)),
                  child: Text('Cancel'),
                  onPressed: () {
                    print('RegisterAndroid cancel onpressed');
                    widget.cancel();
                  },
                )),
              ],
            )
          ],
        ));
  }
}
