import 'package:flutter/material.dart';

class ServiceTitle extends StatelessWidget {
  final String serviceName;
  final String password;
  final String createdAt;

  final Function onLongPress;
  final Function onPressed;
  final Function toEdit;
  final bool passVisible;

  const ServiceTitle({
    super.key,
    required this.serviceName,
    required this.password,
    required this.createdAt,
    required this.onPressed,
    required this.onLongPress,
    required this.passVisible,
    required this.toEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.grey[200]!),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onLongPress: () {
          onLongPress();
        },
        onPressed: () {
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  serviceName,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  passVisible ? password : '********',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  createdAt,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextButton(
                    onPressed: () => toEdit(),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.lightBlueAccent),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
