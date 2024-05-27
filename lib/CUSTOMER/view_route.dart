import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marsproducts/components/commoncolor.dart';
import 'package:marsproducts/components/customSnackbar.dart';
import 'package:marsproducts/controller/controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewRoute extends StatefulWidget {
  String? type;
  String? msg;
  int? br_length;
  ViewRoute({this.type, this.msg, required this.br_length});

  @override
  State<ViewRoute> createState() => _ViewRouteState();
}

class _ViewRouteState extends State<ViewRoute> {
  CustomSnackbar _snackbar = CustomSnackbar();
  final _formKey = GlobalKey<FormState>();
  TextEditingController txtrout = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double topInsets = MediaQuery.of(context).viewInsets.top;
    return Scaffold(
        backgroundColor: P_Settings.detailscolor,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        //  P_Settings.wavecolor,
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(6.0),
        //   child: Center(
        //       child: Text(
        //     " ",
        //     style: TextStyle(color: Colors.white, fontSize: 19),
        //   )),
        // ),
        // ),
        body: SingleChildScrollView(
          child: Consumer<Controller>(builder: (context, values, child) {
            //  List<Map<String, dynamic>> flatList = values.routelist.expand((x) => x).toList();
            return Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: SizedBox(
                //     width: size.width,
                //     height: 50,
                //     child: TextFormField(
                //       controller: txtrout,
                //       decoration: InputDecoration(
                //         enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(20),
                //             borderSide: BorderSide(color: Colors.black)),
                //         focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(20),
                //             borderSide: BorderSide(color: Colors.black)),
                //         suffixIcon: IconButton(
                //             onPressed: () {
                //               Provider.of<Controller>(context, listen: false)
                //                   .searchroute(txtrout.text.toString());
                //             },
                //             icon: Icon(Icons.search)),
                //         hintText: "Search here",
                //       ),
                //       onChanged: (value) =>
                //           Provider.of<Controller>(context, listen: false)
                //               .searchroute(txtrout.text.toString()),
                //     ),
                //   ),
                // ),
                SizedBox(height: 10),
                Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.grey[200],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('CUSTOMER',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            color: Colors.grey[200],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ROUTE',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var item in values.routeflatList)
                      //  var res2 = await OrderAppDB.instance.select_Lati_Longi(item['ACCODE']);
                      TableRow(
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(item["hname"].toString()),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          mapLaunch(double.parse(item["la"]),
                                              double.parse(item["lo"]));
                                        },
                                        child: Text("View in Map")),
                                  ],
                                )),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            );
          }),
        ));
  }

  mapLaunch(double latt, double lonn) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.white,
      // context and builder are
      // required properties in this widget
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 140,
                        child: Text(
                          'Open With  ',
                          style: TextStyle(fontSize: 20),
                        )),
                    InkWell(
                        onTap: () {
                          _launchMaps(latt, lonn);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 32.0,
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.white,
                            child: Image.asset("asset/map.png"),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void _launchMapsWithAddress(String address) async {
  final url =
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    throw 'Could not launch $url';
  }
}

void _launchMaps(double lat, double lon) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
  // if (await canLaunchUrl(Uri.parse(url))) {
  await launchUrl(Uri.parse(url));
  // } else {
  //   throw 'Could not launch $url';
  // }
}
