import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import '../../constants.dart';
import '../../models/organization.dart';
import '../../utilities/api.dart';
import '../../utilities/auth.dart';
import 'package:provider/provider.dart';

class OrganizationScreen extends StatefulWidget {
  const OrganizationScreen({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<OrganizationScreen> createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  late Organization _organization;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadOrganization();
  }

  void loadOrganization() async {
    Response response = await dio().get("/organizations/${widget.id}");

    setState(() {
      _organization = Organization.fromJson(response.data);
      _loading = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TextStyle titleStyle = const TextStyle(
        fontSize: 22.0,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto');

    TextStyle smallStyle =
        titleStyle.copyWith(fontSize: 13.0, fontWeight: FontWeight.normal);

    TextStyle descStyle =
        titleStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.normal);

    TextStyle dynamicStyle = titleStyle.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        color: Provider.of<Auth>(context, listen: false).darkTheme
            ? Colors.white
            : Colors.black);

    TextStyle style = const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat');

    return Scaffold(
        appBar: AppBar(
          title: Text("Info", style: style.copyWith(fontSize: 16)),
          centerTitle: true,
          automaticallyImplyLeading: true,
          backgroundColor: PRIMARY_BLUE,
          elevation: 0,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: SizedBox(
                    width: size.width,
                    child: _loading
                        ? SizedBox(
                            height: size.height,
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: PRIMARY_BLUE,
                            )),
                          )
                        : Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Card(
                                  color: PRIMARY_BLUE,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Container(
                                                width: size.width,
                                                height: size.height / 6,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        fit: BoxFit.scaleDown,
                                                        image: NetworkImage(
                                                            _organization
                                                                .logo)))),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(_organization.name,
                                                  style: titleStyle),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(_organization.location,
                                                  style: smallStyle),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Text(_organization.description,
                                                  style: descStyle)
                                            ],
                                          )
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                                Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    width: size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Services: ",
                                            style: dynamicStyle.copyWith(
                                                fontSize: 16,
                                                color: PRIMARY_BLUE)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          _organization.services,
                                          style: dynamicStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    width: size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Contact Details: ",
                                            style: dynamicStyle.copyWith(
                                                fontSize: 16,
                                                color: PRIMARY_BLUE)),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Phone: ${_organization.phone}",
                                              style: dynamicStyle,
                                            ),
                                            Text(
                                              "Email: ${_organization.email}",
                                              style: dynamicStyle,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )))));
  }
}
