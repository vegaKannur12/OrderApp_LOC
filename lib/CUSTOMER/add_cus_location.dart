import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marsproducts/components/commoncolor.dart';
import 'package:marsproducts/components/customSnackbar.dart';
import 'package:marsproducts/controller/controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomerLOC extends StatefulWidget {
  String? type;
  String? msg;
  int? br_length;
  AddCustomerLOC({this.type, this.msg, required this.br_length});

  @override
  State<AddCustomerLOC> createState() => _AddCustomerLOCState();
}

class _AddCustomerLOCState extends State<AddCustomerLOC> {
  String? cid;
  String? versof;
  String? fingerprint;
  TextEditingController customertext = TextEditingController();
  String? customerName;
  String? areaName;
  String? cstmId;
  String? _selectedItemarea;
  String? _selectedAreaId;
  String? _selectedItemcus;
  String? custmerId;
  CustomSnackbar _snackbar = CustomSnackbar();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<Controller>(context, listen: false).customer_visibility;
    Provider.of<Controller>(context, listen: false)
        .getCustomer(Provider.of<Controller>(context, listen: false).areaId);
    super.initState();
    getCid();
  }

  getCid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cid = prefs.getString("cid");
    versof = prefs.getString("versof");
    fingerprint = prefs.getString("fp");
    print("fingerprint-----$fingerprint");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topInsets = MediaQuery.of(context).viewInsets.top;

    return Scaffold(
        backgroundColor: P_Settings.detailscolor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:
          Colors.white,
          //  P_Settings.wavecolor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.0),
            child: Center(
                child: Text(
              " ",
              style: TextStyle(color: Colors.white, fontSize: 19),
            )),
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<Controller>(builder: (context, values, child) {
            return Form(
              key: _formKey,
              child: SizedBox(  height: size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.01),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Area/Route",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 15),
                      child: Container(
                        child: Autocomplete<Map<String, dynamic>>(
                          optionsBuilder: (TextEditingValue value) {
                            if (value.text.isEmpty) {
                              return [];
                            } else {
                              print("values.areDetails----${values.areDetails}");
                              return values.areDetails.where((suggestion) =>
                                  suggestion["aname"]
                                      .toLowerCase()
                                      .contains(value.text.toLowerCase()));
                            }
                          },
                          displayStringForOption: (Map<String, dynamic> option) =>
                              option["aname"],
                          onSelected: (value) {
                            setState(() {
                              _selectedItemarea = value["aname"];
                              areaName = value["aname"];
                              print("areaName...$areaName");
                              _selectedAreaId = value["aid"];
                              Provider.of<Controller>(context, listen: false)
                                  .selectedAreaId = _selectedAreaId;
                              Provider.of<Controller>(context, listen: false)
                                  .areaAutoComplete = [
                                _selectedAreaId!,
                                _selectedItemarea!,
                              ];
                
                              print("hjkkllsjm----$_selectedAreaId");
                              print(
                                  "${Provider.of<Controller>(context, listen: false).areaAutoComplete}");
                              Provider.of<Controller>(context, listen: false)
                                  .areaSelecton = _selectedItemarea;
                              Provider.of<Controller>(context, listen: false)
                                  .areaId = _selectedAreaId;
                              customertext.text = '';
                
                              Provider.of<Controller>(context, listen: false)
                                  .getCustomer(_selectedAreaId);
                            });
                          },
                          fieldViewBuilder: (BuildContext context,
                              fieldText,
                              FocusNode fieldFocusNode,
                              VoidCallback onFieldSubmitted) {
                            return SizedBox(
                              height: size.height * 0.1,
                              child: TextFormField(
                                // scrollPadding: EdgeInsets.only(
                                //     top: 500,),
                                maxLines: 1,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromARGB(255, 199, 198, 198),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color:
                                          const Color.fromARGB(255, 199, 198, 198),
                                      width: 1.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    gapPadding: 1,
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 3,
                                    ),
                                  ),
                
                                  hintText: 'Area / Route',
                                  helperText: ' ', // th
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      fieldText.clear();
                                      _selectedAreaId = ' ';
                                      Provider.of<Controller>(context,
                                              listen: false)
                                          .getCustomer(_selectedAreaId);
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please choose area!!';
                                  }
                                  return null;
                                },
                                textInputAction: TextInputAction.next,
                
                                controller: fieldText,
                                focusNode: fieldFocusNode,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                          optionsViewBuilder: (BuildContext context,
                              AutocompleteOnSelected<Map<String, dynamic>>
                                  onSelected,
                              Iterable<Map<String, dynamic>> options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: SizedBox(
                                  height: size.height * 0.2,
                                  width: size.width * 0.84,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(2.0),
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final Map<String, dynamic> option =
                                          options.elementAt(index);
                                      print("option----$option");
                                      return SizedBox(
                                        height: size.height * 0.05,
                                        child: ListTile(
                                          onTap: () {
                                            onSelected(option);
                                            print(
                                                "optionaid------${option["aid"]}");
                                          },
                                          title: Text(option["aname"].toString(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Customer",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Autocomplete<Map<String, dynamic>>(
                                  optionsBuilder: (TextEditingValue value) {
                                    if (value.text.isEmpty) {
                                      return [];
                                    } else {
                                      print("TextEditingValue---${value.text}");
                                      return values.custmerDetails.where(
                                          (suggestion) => suggestion["hname"]
                                              .toLowerCase()
                                              .startsWith(
                                                  value.text.toLowerCase()));
                                    }
                                  },
                                  displayStringForOption:
                                      (Map<String, dynamic> option) =>
                                          option["hname"].toUpperCase(),
                                  onSelected: (value) {
                                    setState(() {
                                      print("value----$value");
                                      _selectedItemcus = value["hname"];
                                      customerName = value["hname"].toUpperCase();
                                      custmerId = value["ac_code"];
                                      print("Code .........---$custmerId");
                                      Provider.of<Controller>(context,
                                                  listen: false)
                                              .customer_Name =
                                          values.customer_Name.toString();
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      fieldText,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted) {
                                    print("fieldText----$fieldText");
                                    return SizedBox(
                                      // height: size.height * 0.1,
                                      child: TextFormField(
                                        readOnly: true,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 199, 198, 198),
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: const Color.fromARGB(
                                                  255, 199, 198, 198),
                                              width: 1.0,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            gapPadding: 0.3,
                                            borderRadius: BorderRadius.circular(20),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                              width: 3,
                                            ),
                                          ),
                                          helperText: ' ',
                                          hintText: 'Customer Name',
                                          // helperText: ' ',
                                          prefixIcon: IconButton(
                                            onPressed: () {
                                              print(
                                                  "szfjzjfnjd------$_selectedAreaId");
                
                                              print(
                                                  "values.custmerDetails-----------${values.custmerDetails}");
                
                                              showModalBottomSheet<void>(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Container(
                                                    height: values.custmerDetails
                                                            .isNotEmpty
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.65
                                                        : size.height * 0.2,
                                                    color: Colors.white,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                          values.custmerDetails
                                                                  .isNotEmpty
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons
                                                                                .close))
                                                                  ],
                                                                )
                                                              : Container(),
                                                          values.custmerDetails
                                                                      .isNotEmpty &&
                                                                  values
                                                                      .custmerDetails
                                                                      .isNotEmpty
                                                              ? const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 0.0),
                                                                  child: Text(
                                                                    'Customers',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                )
                                                              : const Text(''),
                                                          values.custmerDetails
                                                                  .isNotEmpty
                                                              ? const Divider(
                                                                  indent: 50,
                                                                  endIndent: 50,
                                                                  thickness: 1,
                                                                )
                                                              : const Text(""),
                                                          values.custmerDetails
                                                                  .isNotEmpty
                                                              ? Expanded(
                                                                  child: Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(
                                                                              left:
                                                                                  10,
                                                                              top:
                                                                                  3),
                                                                      child: ListView
                                                                          .builder(
                                                                        itemCount: values
                                                                            .custmerDetails
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return ListTile(
                                                                            trailing:
                                                                                const Icon(Icons.arrow_circle_right_rounded),
                                                                            onTap:
                                                                                () {
                                                                              // WidgetsBinding
                                                                              //     .instance
                                                                              //     .addPostFrameCallback((_) {
                                                                              //   Provider.of<Controller>(context, listen: false).getBalance(
                                                                              //       cid,
                                                                              //       values.custmerDetails[index]['ac_code']!,
                                                                              //       context);
                                                                              //   Provider.of<Controller>(context, listen: false).selectmarked(context,
                                                                              //       custmerId.toString());
                                                                              // });
                                                                              setState(
                                                                                  () {
                                                                                customertext.text =
                                                                                    values.custmerDetails[index]['hname'];
                                                                                custmerId =
                                                                                    values.custmerDetails[index]['ac_code'];
                                                                              });
                                                                              FocusManager
                                                                                  .instance
                                                                                  .primaryFocus
                                                                                  ?.unfocus();
                                                                              // Provider.of<Controller>(context, listen: false).setCustomerName(values.custmerDetails[index]['hname']);
                                                                              // Navigator.of(context).push(
                                                                              //   PageRouteBuilder(
                                                                              //     opaque: false, // set to false
                                                                              //     pageBuilder: (_, __, ___) => OrderForm(widget.areaname, "sales"),
                                                                              //   ),
                                                                              // );
                                                                              //      customerName =
                                                                              // values.custmerDetails[index]
                                                                              //     ['hname'];
                                                                              print(
                                                                                  "customer name.......${Provider.of<Controller>(context, listen: false).customer_Name}");
                                                                              Navigator.pop(
                                                                                  context);
                                                                            },
                                                                            visualDensity: const VisualDensity(
                                                                                horizontal:
                                                                                    -4,
                                                                                vertical:
                                                                                    -4),
                                                                            textColor:
                                                                                P_Settings.wavecolor,
                                                                            title:
                                                                                Text(
                                                                              "${values.custmerDetails[index]['hname']}",
                                                                              style: const TextStyle(
                                                                                  fontSize: 13,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                
                                                                            // onTap: (() {
                                                                            //   print("selected index");
                                                                            // }),
                                                                          );
                                                                        },
                                                                      )),
                                                                )
                                                              : Text(
                                                                  "No Customer Found!!!",
                                                                  style: TextStyle(
                                                                      fontSize: 17,
                                                                      color: P_Settings
                                                                          .extracolor),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.book,
                                              size: 15,
                                            ),
                                          ), // th
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                customertext.clear();
                                                fieldText.clear();
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please choose Customer!!!';
                                          }
                                          return null;
                                        },
                                        controller: customertext.text != null
                                            ? customertext
                                            : fieldText,
                                        scrollPadding: EdgeInsets.only(
                                            bottom: topInsets + size.height * 0.34),
                                        focusNode: fieldFocusNode,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                  optionsMaxHeight: size.height * 0.02,
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<Map<String, dynamic>>
                                          onSelected,
                                      Iterable<Map<String, dynamic>> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: SizedBox(
                                          width: size.width * 0.84,
                                          height: size.height * 0.2,
                                          child: ListView.builder(
                                            padding: const EdgeInsets.all(10.0),
                                            itemCount: options.length,
                                            itemBuilder:
                                                (BuildContext context, int index) {
                                              //      print(
                                              // "option----${options}");
                                              print("index----$index");
                                              final Map<String, dynamic> option =
                                                  options.elementAt(index);
                                              print("option----$option");
                                              return SizedBox(
                                                height: size.height * 0.05,
                                                child: ListTile(
                                                  onTap: () async {
                                                    print(
                                                        "optonsssssssssssss$option");
                                                    onSelected(option);
                                                    final prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setString('cus_id',
                                                        option["ac_code"]);
                                                    // Provider.of<Controller>(
                                                    //             context,
                                                    //             listen:
                                                    //                 false)
                                                    //         .custmerSelection =
                                                    //     option["code"];
                                                  },
                                                  title: Text(
                                                      option["hname"].toString(),
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 15.0,
                          ),
                          label: const Text(
                            "Add Location",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print("custmerId.toString()${custmerId.toString()}");
                              await Provider.of<Controller>(context, listen: false)
                                  .mark_custLoc(context, custmerId.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: P_Settings.wavecolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    values.cusMarkLoad
                        ? SpinKitThreeBounce(
                            color: Colors.blue,
                            size: 15,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [values.cusMark]),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
