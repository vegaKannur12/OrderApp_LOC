import 'package:flutter/material.dart';
import 'package:marsproducts/db_helper.dart';
import 'package:marsproducts/screen/ORDER/1_companyRegistrationScreen.dart';

class Unreg {
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () async {

      //  await OrderAppDB.instance.deleteAllTables();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RegistrationScreen()));
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () { Navigator.pop(context, false);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => RegistrationScreen()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Do you want to unregister!!"),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
