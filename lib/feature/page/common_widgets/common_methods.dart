import 'package:open_filex/open_filex.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/assets_manager.dart';

authsnackbar(String text, BuildContext context, [double width = 80]) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  return SnackBar(
    content: Container(
      margin: EdgeInsets.symmetric(horizontal: width),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(
                ImageAssets.repcoLogo,
                // scale: 3,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(5),
  );
}

void _pickFile() async {
  final result = await FilePicker.platform.pickFiles(allowMultiple: true);

  if (result == null) return;

  final file = result.files.first;
  print(file.path);
  _openFile(file);
}

void _openFile(PlatformFile file) {
  OpenFilex.open(file.path);
}

Future<void> showAlertOpenDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Do you want to open downloaded folder ?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ), 
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              _pickFile();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
