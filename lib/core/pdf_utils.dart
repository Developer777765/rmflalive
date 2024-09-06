
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

Future<Uint8List> makePdf(
  List<Map<String, dynamic>> data,
) async {
  final pdf = Document();
  final myHelvetica =
      Font.ttf(await rootBundle.load('assets/fonts/Helvetica.ttf'));

  for (var i = 0; i < data.length; i += 9) {
    final dataPage = data.skip(i).take(9).toList();
    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return Container(
            child: reportDesign(dataPage, myHelvetica),
          );
        },
      ),
    );
  }
  return pdf.save();
}

Future<Uint8List> makePdf2(
  List<Map<String, dynamic>> data,
) async {
  final pdf = Document();
  final myHelvetica =
      Font.ttf(await rootBundle.load('assets/fonts/Helvetica.ttf'));
  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return Container(child: summaryReportDesign(data, myHelvetica));
      },
    ),
  );
  return pdf.save();
}

Widget summaryReportDesign(List<Map<String, dynamic>> data, Font myHelvetica) {
  return Column(children: [
    Table(border: TableBorder.all(), children: [
      TableRow(
        decoration: const BoxDecoration(),
        children: [
          Padding(
            child: Text('Summary Collection List',
                style: TextStyle(font: Font.helveticaBold())),
            padding: const EdgeInsets.all(15),
          ),
          Padding(
            child:
                Text('Reports', style: TextStyle(font: Font.helveticaBold())),
            padding: const EdgeInsets.all(15),
          ),
        ],
      ),
      for (int i = 0; i < data.length; i++) tablerow(data[i], myHelvetica)
    ])
  ]);
}

TableRow tablerow(Map<String, dynamic> data, Font myHelvetica) {
  var tableRow;
  data.forEach((key, value) {
    tableRow = TableRow(
      decoration: const BoxDecoration(),
      children: [
        Padding(
          child: Text(key, style: TextStyle(font: myHelvetica)),
          padding: const EdgeInsets.all(15),
        ),
        Padding(
          child: Text(value, style: TextStyle(font: myHelvetica)),
          padding: const EdgeInsets.all(15),
        ),
      ],
    );
  });

  return tableRow;
}

Widget reportDesign(List<Map<String, dynamic>> data, Font myHelvetica) {
  return Column(children: [
    Table(border: TableBorder.all(), children: [
      TableRow(children: headerRow(data, myHelvetica)),
      for (int i = 0; i < data.length; i++)
        TableRow(
          children: childRow(data[i], myHelvetica),
        )
    ])
  ]);
}

List<Widget> headerRow(List<Map<String, dynamic>> data, Font myHelvetica) {
  List<Widget> header = [];
  data[0].forEach((key, value) {
    header.add(
      Padding(
        child: Text(key.toUpperCase(),
            style: TextStyle(
                font: Font.helveticaBold(),
                color: PdfColor.fromHex("#0000FF"))),
        padding: const EdgeInsets.all(15),
      ),
    );
  });
  return header;
}

List<Widget> childRow(Map<String, dynamic> data, Font myHelvetica) {
  List<Widget> childRow = [];
  data.forEach((key, value) {
    childRow.add(
      Padding(
        child: Text(value.toString(), style: TextStyle(font: Font.helvetica())),
        padding: const EdgeInsets.all(15),
      ),
    );
  });
  return childRow;
}


