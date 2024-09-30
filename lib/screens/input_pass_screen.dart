import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//components
import 'package:passkeep/components/rounded_button.dart';

//styles
import 'package:passkeep/constants/styles.dart';

//data manage
import '../providers/data_list.dart';

//utils
import '../utils/pass_generator.dart';

class InputPassScreen extends StatefulWidget {
  const InputPassScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<InputPassScreen> createState() => _InputPassScreenState();
}

class _InputPassScreenState extends State<InputPassScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _serviceNameController = TextEditingController();
  String actionTextButton = 'Save';

  @override
  void initState() {
    super.initState();
    if(widget.serviceId.isNotEmpty){
      actionTextButton = 'Update';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<DataList>(context, listen: false)
            .getServiceById(widget.serviceId);
        _controller.text = Provider.of<DataList>(context, listen: false).newPass;
        _serviceNameController.text =
            Provider.of<DataList>(context, listen: false).newService;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, DataList dataList, child) {
      return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 1.0,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _serviceNameController,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: kInputDecoration.copyWith(
                      label: const Text('Service'),
                      hintText: 'Enter the service name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _serviceNameController.text = value;
                        dataList.newServiceName(value);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),

                  TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    decoration: kInputDecoration.copyWith(
                      label: const Text('Password (min 8 characters)'),
                      hintText: 'Enter new password',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _controller.text = value;
                        dataList.newPassValue(value);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Password Strength: ${dataList.strength.round()}',
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Slider(
                    value: dataList.strength,
                    onChanged: (double value) {
                      setState(() {
                        dataList.updateStrength(value);
                      });
                    },
                    min: 8,
                    max: 25,
                    divisions: 17,
                    label: dataList.strength.round().toString(),
                  ),

                  RoundedButton(
                    title: 'Generate',
                    colour: Colors.lightBlue,
                    onPressed: () {
                      setState(() {
                        _controller.text =
                            passGenerator(dataList.strength.round());
                        dataList.newPassValue(_controller.text);
                      });
                    },
                  ),

                  RoundedButton(
                    title: dataList.inputFilled() ? actionTextButton : 'Fill the fields',
                    colour: dataList.inputFilled() ? Colors.green : Colors.grey,
                    onPressed: () {
                      if (dataList.inputFilled()) {
                        if (widget.serviceId.isNotEmpty) {
                          dataList.updateServiceById(
                              widget.serviceId);
                        } else {
                          dataList.saveData(
                              dataList.newService, dataList.newPass);

                        }
                        dataList.resetProvider();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
