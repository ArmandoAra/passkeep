import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//components
import 'package:passkeep/components/rounded_button.dart';

//styles
import 'package:passkeep/constants/styles.dart';

//data manage
import '../data/data_list.dart';

//utils
import '../utils/pass_generator.dart';

// Metodo que retorna un widget para ser usado en el showModalBottomSheet
class AddPassScreen extends StatefulWidget {
  const AddPassScreen({super.key});

  @override
  State<AddPassScreen> createState() => _AddPassScreenState();
}

class _AddPassScreenState extends State<AddPassScreen> {

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
          return Container(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: <Widget>[
                    //Input para el nombre del servicio
                    TextField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      decoration: kInputDecoration.copyWith(
                        label: Text('Service'),
                        hintText: 'Enter the service name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          dataList.newServiceName(value);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    //Input para la contraseña
                    TextField(
                      controller: _controller,  // Reutiliza el mismo controlador
                      textAlign: TextAlign.center,
                      decoration: kInputDecoration.copyWith(
                        label: Text('Password (min 8 characters)'),
                        hintText: 'Enter new password',
                      ),
                      onChanged: (value) {
                        setState(() {
                          dataList.newPassValue(value);  // Actualiza tu lógica de negocio
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Password Strength: ${dataList.strength.round()}',
                      style: TextStyle(
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
                          _controller.text = passGenerator(dataList.strength.round());
                          dataList.newPassValue(_controller.text);
                        });
                      },
                    ),

                    //Boton para guardar la contraseña
                    RoundedButton(
                      title:
                          dataList.inputFilled() ? 'Save' : 'Fill the fields',
                      colour:
                          dataList.inputFilled() ? Colors.green : Colors.grey,
                      onPressed: () {
                        //guardando el estado del servicio que se esta creando
                        if (dataList.inputFilled()) {
                          dataList.addService(
                              dataList.newService, dataList.newPass);
                          dataList.resetProvider();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

