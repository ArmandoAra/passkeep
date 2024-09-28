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

// Metodo que retorna un widget para ser usado en el showModalBottomSheet
class EditPassScreen extends StatefulWidget {
  const EditPassScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  State<EditPassScreen> createState() => _EditPassScreenState();
}

class _EditPassScreenState extends State<EditPassScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _serviceNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DataList>(context, listen: false)
          .getServiceById(widget.serviceId);
      _controller.text = Provider.of<DataList>(context, listen: false).newPass;
      _serviceNameController.text =
          Provider.of<DataList>(context, listen: false).newService;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _serviceNameController.dispose();
    super.dispose();
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
                  //Slider para la fortaleza de la contraseña
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
                  //Boton para generar contraseña
                  RoundedButton(
                    title: 'Generate',
                    colour: Colors.lightBlue,
                    onPressed: () {
                      //Generar contraseña
                      setState(() {
                        _controller.text =
                            passGenerator(dataList.strength.round());
                        dataList.newPassValue(_controller.text);
                      });
                    },
                  ),

                  //Boton para guardar
                  RoundedButton(
                    title: dataList.inputFilled() ? 'Save' : 'Fill the fields',
                    colour: dataList.inputFilled() ? Colors.green : Colors.grey,
                    onPressed: () {
                      if (dataList.inputFilled()) {
                        dataList.updateServiceById(widget.serviceId);
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
