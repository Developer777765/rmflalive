import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/core/router.dart';
import '/data/datasource/loacal_database/sql_helper_repco.dart';
import '/feature/page/loan_collection/loan_collection_group_screen.dart';

import '../../../core/value_manger.dart';
import '../../provider/auto_logout_provider.dart';

final filterResetProvider = StateProvider<bool>((ref) {
  return false;
});

final groupCodeControllerProvider = StateProvider<String>((ref) {
  return '';
});

final groupNameControllerProvider = StateProvider((ref) {
  return "";
});

final loanNoControllerProvider = StateProvider((ref) {
  return "";
});

final borrowerNamecontrollerProvider = StateProvider((ref) {
  return "";
});

class LoanFiltterScreen extends ConsumerStatefulWidget {
  const LoanFiltterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoanFiltterScreenState();
}

class _LoanFiltterScreenState extends ConsumerState<LoanFiltterScreen> {
  var groupCodeController = TextEditingController();
  var groupNameController = TextEditingController();
  var loanNoController = TextEditingController();
  var borrowerNamecontroller = TextEditingController();

  @override
  void initState() {
    groupCodeController.text = ref.read(groupCodeControllerProvider);
    groupNameController.text = ref.read(groupNameControllerProvider);
    loanNoController.text = ref.read(loanNoControllerProvider);
    borrowerNamecontroller.text = ref.read(borrowerNamecontrollerProvider);
    super.initState();
  }

  Future<void> onSummit(
      {required WidgetRef ref,
      required String groupCode,
      required String groupName,
      required String loanNo,
      required String borrowerName}) async {
    final groupbydata = ref.read(groupBydataProvider.notifier);
    ref.read(filterResetProvider.notifier).state = true;
    var data1 = await ref.read(sqlHelperProvider).filterLoanList(
        searchTerm: groupCode,
        groupName: groupName,
        loanNo: loanNo,
        borrowerName: borrowerName);
    debugPrint("groupData : $data1 ");
    groupbydata.update((state) => data1);
    ref
        .read(groupCodeControllerProvider.notifier)
        .update((state) => groupCodeController.text);
    ref
        .read(groupNameControllerProvider.notifier)
        .update((state) => groupNameController.text);
    ref
        .read(loanNoControllerProvider.notifier)
        .update((state) => loanNoController.text);
    ref
        .read(borrowerNamecontrollerProvider.notifier)
        .update((state) => borrowerNamecontroller.text);
  }

  @override
  Widget build(BuildContext context) {
    return generalsession(
      ref: ref,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          actions: [
            TextButton(
                onPressed: () {
                  groupCodeController.text = '';
                  groupNameController.text = '';
                  loanNoController.text = '';
                  borrowerNamecontroller.text = '';
                  //--
                  ref
                      .read(groupCodeControllerProvider.notifier)
                      .update((state) => '');
                  ref
                      .read(groupNameControllerProvider.notifier)
                      .update((state) => '');
                  ref
                      .read(loanNoControllerProvider.notifier)
                      .update((state) => '');
                  ref
                      .read(borrowerNamecontrollerProvider.notifier)
                      .update((state) => '');
                },
                child: Text("Clear Filter",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)))
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ])),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(Apppadding.p12),
          child: Column(
            children: [
              FilterTextfield(
                  onChanged: () {},
                  controller: groupCodeController,
                  labelName: 'Group Code'),
              FilterTextfield(
                  onChanged: () {},
                  controller: groupNameController,
                  labelName: 'Group Name'),
              FilterTextfield(
                  onChanged: () {},
                  controller: loanNoController,
                  keyboardType: TextInputType.number,
                  labelName: 'Loan No'),
              FilterTextfield(
                  onChanged: () {},
                  controller: borrowerNamecontroller,
                  labelName: 'Borrower Name'),
              Expanded(
                child: Container(
                  child: Center(
                    child: FloatingActionButton(
                      elevation: AppSize.s10,
                      child: const Icon(Icons.arrow_forward_ios),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () async {
                        if (groupCodeController.text == "" &&
                            groupNameController.text == "" &&
                            loanNoController.text == '' &&
                            borrowerNamecontroller.text == "") {
                          GoRouter.of(context)
                              .pushReplacementNamed(Routes.loanCollection);
                        } else {
                          await onSummit(
                            ref: ref,
                            groupCode: groupCodeController.text,
                            borrowerName: borrowerNamecontroller.text,
                            groupName: groupNameController.text,
                            loanNo: loanNoController.text,
                          );
                          // groupCodeController.clear();
                          // borrowerNamecontroller.clear();
                          // groupNameController.clear();

                 
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class FilterTextfield extends StatelessWidget {
  FilterTextfield(
      {required this.controller,
      required this.labelName,
      required,
      this.keyboardType = TextInputType.text,
      required this.onChanged});
  String labelName;
  TextInputType? keyboardType;
  TextEditingController controller;
  void Function()? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      onTap: onChanged,
      decoration: InputDecoration(
          labelText: labelName,
          focusedBorder:
              const UnderlineInputBorder(borderSide: BorderSide(width: 1.5)),
          enabledBorder:
              const UnderlineInputBorder(borderSide: BorderSide(width: 1))),
    );
  }
}
