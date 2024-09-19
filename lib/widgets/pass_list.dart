import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service_title.dart';

//models
import '../models/service.dart';

//data
import '../data/data_list.dart';


class ServiceList extends StatelessWidget {
  const ServiceList({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<DataList>(
      builder: (context,dataList, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            //Guarda la tarea en la variable task para poder acceder
            // a sus propiedades mas facilmente
            final Service service = dataList.servicesUnmodifiable[index];
            return ServiceTitle(
              serviceName: service.name,
              password: service.password,
              createdAt: service.createdAt,
              onLongPress: () {
                //Copiar al portapapeles
              },

            );
          },
          itemCount:dataList.servicesLength,
        );
      },
    );
  }
}
