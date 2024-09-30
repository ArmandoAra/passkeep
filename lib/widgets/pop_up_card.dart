import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

//data
import '../providers/data_list.dart';

class PopupCardDetails extends StatelessWidget {
  const PopupCardDetails(
      {super.key, required this.serviceName, required this.id});

  final String serviceName;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataList>(builder: (context, dataList, child) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: math.min(450, MediaQuery.sizeOf(context).width - 16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                serviceName,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Do you want to delete this service?',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 8.0),
            const Divider(),
            TextButton(
              onPressed: () =>
                  {dataList.deleteService(id), Navigator.pop(context)},
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('yes, delete',
                  style: TextStyle(fontSize: 16.0, color: Colors.redAccent)),
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      );
    });
  }
}
