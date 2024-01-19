import 'package:firebase_datastoree/login%20and%20signup/login.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  var formkey = GlobalKey<FormState>();
  String? pass;// to collect value from pwd field
  var pwdcontroller = TextEditingController();
  var is_pwd_hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Email"),
                  validator: (email) {
                    if (email!.isEmpty || !email.contains('@')) {
                      return "invalid email/ or empty field";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: pwdcontroller,
                  validator: (pwd) {
                    pass = pwd;
                    if (pwd!.isEmpty || pwd.length < 6) {
                      return "length should be > 6 / field must not be empty";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if(is_pwd_hidden == true){
                                is_pwd_hidden = false;
                              }else{
                                is_pwd_hidden = true;
                              }
                            });
                          },
                          icon: Icon(is_pwd_hidden == true
                              ? Icons.visibility_off
                              : Icons.visibility)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Password"),
                  obscureText: is_pwd_hidden,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (cpwd) {
                    //if(cpwd != pwdcontroller.text)
                    if (cpwd != pass) {
                      return "password must be same";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      hintText: "Confirm Password"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple),
                    onPressed: () {
                      var valid = formkey.currentState?.validate();
                      if (valid == true) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Please check the fields")));
                      }
                    },
                    child: const Text("Register Here",
                        style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
