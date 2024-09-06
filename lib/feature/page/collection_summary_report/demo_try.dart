// import 'package:clean_my_temp/app/value_manger.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class CollectionSummaryReportScreen extends StatefulWidget {
//   const CollectionSummaryReportScreen({super.key});

//   @override
//   State<CollectionSummaryReportScreen> createState() =>
//       _CollectionSummaryReportScreenState();
// }

// class _CollectionSummaryReportScreenState
//     extends State<CollectionSummaryReportScreen> {
//   @override
//   void initState() {
//     dateinput.text = ""; //set the initial value of text field
//     super.initState();
//   }

//   String selectedValue = "select";
//   List<DropdownMenuItem<String>> get dropdownItems {
//     List<DropdownMenuItem<String>> menuItems = [
//       DropdownMenuItem(
//         child: Text("Select"),
//         value: "select",
//       ),
//       DropdownMenuItem(
//         child: Text("EXCEL"),
//         value: "excel",
//       ),
//       DropdownMenuItem(
//         child: Text("PDF"),
//         value: "pdf",
//       ),
//     ];
//     return menuItems;
//   }

//   TextEditingController dateinput = TextEditingController();

//   DateTime? _selectedDate;
//   // void _datePick() async {
//   //   DateTime? pickedDate = await showDatePicker(
//   //       context: context,
//   //       initialDate: DateTime.now(),
//   //       firstDate: DateTime(
//   //           2000), //DateTime.now() - not to allow to choose before today.
//   //       lastDate: DateTime(2101));

//   //   if (pickedDate != null) {
//   //     print(pickedDate);
//   //     String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//   //     print(formattedDate);

//   //     setState(() {
//   //       dateinput.text = formattedDate;
//   //     });
//   //   } else {
//   //     print("Date is not selected");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     TextEditingController dateinput = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Collection Summary Report "),
//         centerTitle: false,
//         actions: [],
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                   colors: [
//                 Theme.of(context).colorScheme.primary,
//                 Theme.of(context).colorScheme.primary.withOpacity(0.7),
//               ])),
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(Apppadding.p10),
//         child: Column(
//           children: [
//             TextFormField(
//               style: Theme.of(context).textTheme.headlineSmall,
//               readOnly: true,
//               controller: dateinput,
//               onTap: () async {
//                 DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(
//                         2000), //DateTime.now() - not to allow to choose before today.
//                     lastDate: DateTime(2101));

//                 if (pickedDate != null) {
//                   print(
//                       pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//                   String formattedDate =
//                       DateFormat('yyyy-MM-dd').format(pickedDate);
//                   print(
//                       formattedDate); //formatted date output using intl package =>  2021-03-16
//                   //you can implement different kind of Date Format here according to your requirement

//                   setState(() {
//                     dateinput.text =
//                         formattedDate; //set output date to TextField value.
//                   });
//                 } else {
//                   print("Date is not selected");
//                 }
//               },
//               decoration: InputDecoration(
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_month),
//                     onPressed: () {
//                       // _datePick();
//                       setState(() {});
//                     },
//                   ),
//                   labelText: "From Date (dd/mm/yyyy)",
//                   focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           width: 1,
//                           color: Theme.of(context).colorScheme.primary)),
//                   enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           width: 1,
//                           color: Theme.of(context).colorScheme.secondary))),
//             ),
//             SizedBox(
//               height: size.height * 0.02,
//             ),
//             TextFormField()
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.all(Apppadding.p8),
//         height: size.height * 0.10,
//         width: size.width,
//         color: Theme.of(context).colorScheme.secondaryContainer,
//         child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//           SizedBox(
//             width: size.width * 0.4,
//             height: size.width * 0.1,
//             child: ElevatedButton(
//               onPressed: () {},
//               child: Text(
//                 "print",
//                 style: Theme.of(context).textTheme.labelLarge,
//               ),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor:
//                       Theme.of(context).colorScheme.primaryContainer,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5))),
//             ),
//           ),
//           Column(
//             children: [
//               Text(
//                 "Export to",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodySmall!
//                     .copyWith(color: Theme.of(context).colorScheme.outline),
//               ),
//               DropdownButton(
//                   value: selectedValue,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedValue = newValue!;
//                     });

//                     if (selectedValue == "select") {
//                       print("sync selected" + selectedValue.toString());
//                     } else if (selectedValue == "excel") {
//                       print(" excel selected" + selectedValue.toString());
//                     } else if (selectedValue == "pdf") {
//                       print(" pdf selected" + selectedValue.toString());
//                     }
//                   },
//                   items: dropdownItems)
//             ],
//           )
//         ]),
//       ),
//     );
//   }
// }
// // write textfield date picker program in flutter