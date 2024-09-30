import 'package:flutter/material.dart';
import 'package:passkeep/screens/root_screen.dart';
import 'package:provider/provider.dart';

import '../providers/data_list.dart';
import '../providers/auth.dart';

import '../widgets/pass_list.dart';

import 'input_pass_screen.dart';

class PassScreen extends StatefulWidget {
  static const String id = 'pass_screen';

  const PassScreen({super.key});
  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  @override
  void initState() {
    super.initState();
    Auth auth = Provider.of<Auth>(context, listen: false);

    if (auth.isAuth) {
      Provider.of<DataList>(context, listen: false).readData();
    }
    // Provider.of<DataList>(context, listen: false).readData();
  }

  @override
  Widget build(BuildContext context) {

    if (Provider.of<Auth>(context).isAuth) {
      return Scaffold(
        backgroundColor: Colors.lightBlueAccent,

        floatingActionButton: FloatingActionButton(
          heroTag: 'add',
          backgroundColor: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Provider.of<DataList>(context, listen: false).resetProvider();
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => const InputPassScreen(serviceId: '',),
            );
          },
        ),

        body: Consumer(
          builder: (context, DataList dataList, child) {
            return Column(
              children: <Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 58.0),
                    child: Text(
                      'Pass Keeper',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Tap to',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 2.0, right: 2.0, bottom: 5.0),
                            child: Text(
                              'Copy',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                          Text(
                            'the password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Long press to',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2.0, right: 2.0, bottom: 5.0),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.redAccent[400],
                                fontSize: 22.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 30.0, right: 30.0, bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        '${dataList.servicesLength}'
                        ' ${dataList.servicesLength > 1 ? 'Services' : 'Service'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      Switch(
                        value: dataList.isPassVisible,
                        activeColor: Colors.blueAccent,
                        onChanged: (value) {
                          dataList.togglePassVisibility();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: const ServiceList(),
                  ),
                ),
              ],
            );
          },
        ),
      );
    } else {
      return const RootScreen();
    }
  }
}
