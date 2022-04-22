library chip_emails;

import 'package:flutter/material.dart';

/// A Calculator.
// ignore: must_be_immutable
class EmailChips extends StatefulWidget {
  List<String> emails = [];
  Color? backgroundcolor;
  final VoidCallback press;
  TextEditingController editingController;
  EmailChips({ required this.press, required this.emails, required this.editingController,   this.backgroundcolor} )
     ;

  @override
  State<EmailChips> createState() => _EmailChipsState();
}

class _EmailChipsState extends State<EmailChips> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              child: Center(
            child:
 Padding(
   padding:  EdgeInsets.symmetric(horizontal: 10.0),
   child:
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...widget.emails
                      .map(
                        (email) => Chip(

                          label: Text(email),
                          onDeleted: () => {
                            setState(() {
                              widget.emails
                                  .removeWhere((element) => email == element);
                            })
                          },
                        backgroundColor: widget.backgroundcolor,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ))),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 300,
            child: TextField(
              decoration:
                  const InputDecoration.collapsed(hintText: 'Invite By Email'),
              controller: widget.editingController,
              onChanged: (String val) {
                if (val.endsWith(' ')) {
                  setState(() {
                    widget.emails.add(widget.editingController.text);
                    widget.editingController.text = '';
                  });
                }
              },
              onEditingComplete: () {
                setState(() {
                  widget.emails.add(widget.editingController.text);
                  widget.editingController.text = '';
                });
              },
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: widget.press,
              child: Container(
                height: 50,
                width: 100,
                color: Colors.black,
                child: const Center(
                    child: Text(
                  "Get Emails",
                  style: TextStyle(color: Colors.white),
                )),
              ))
        ],
      ),
    );
  }
}
