import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class UnknownScreen extends ConsumerStatefulWidget {
  const UnknownScreen({required this.name, required this.code});
  final String name;
  final String code;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UnknownScreenState();
}

class _UnknownScreenState extends ConsumerState<UnknownScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.name.toString(),
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                Color(0xff006334),
                Color(0xff10DC79),
              ])),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(widget.name), Text(widget.code)],
      ),
    );
  }
}
