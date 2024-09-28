import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service_title.dart';

import './pop_up_card.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import '../screens/edit_pass_screen.dart';

//models
import '../models/service.dart';

//data
import '../providers/data_list.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  Future<void> _onLongPressToDelete(context, serviceName, id) async {
    final result = await showPopupCard<String>(
      context: context,
      builder: (context) {
        return PopupCard(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: PopupCardDetails(serviceName: serviceName, id: id),
        );
      },
      offset: const Offset(-8, 60),
      alignment: Alignment.topRight,
      useSafeArea: true,
      dimBackground: true,
    );
    if (result == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataList>(
      builder: (context, dataList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            //Guarda la tarea en la variable task para poder acceder
            // a sus propiedades mas facilmente
            final Service service = dataList.servicesUnmodifiable[index];
            return ServiceTitle(
              serviceName: service.name,
              password: service.password,
              createdAt: service.createdAt,
              passVisible: dataList.isPassVisible,
              //Editar la tarea
              toEdit: () {
                Provider.of<DataList>(context, listen: false).resetProvider();
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => EditPassScreen(
                    serviceId: service.id.toString(),
                  ),
                );
              },
              onPressed: () {
                //Copiar al portapapeles
                dataList.copyToClipboard(service.password);
              },
              onLongPress: () {
                _onLongPressToDelete(context, service.name, service.id);
                //
              },
            );
          },
          itemCount: dataList.servicesLength,
        );
      },
    );
  }
}
