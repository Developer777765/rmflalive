import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:menthee_flutter_project/feature/page/home/home_screen.dart';
import 'package:menthee_flutter_project/feature/provider/network_listener_provider.dart';
import '/core/router.dart';
import '/feature/page/loan_collection/loan_filter_screen.dart';
import '/feature/provider/loan_collection_response_provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/value_manger.dart';
import '../../../data/datasource/loacal_database/money_collection_datasource.dart';
import '../../../domain/entity/loan_collection_res_entity.dart';
import '../../provider/auto_logout_provider.dart';
import 'loan_collection_screen.dart';

final badgeCountProvider = StateProvider<int>((ref) {
  return 0;
});
final groupBydataProvider = StateProvider<List<ResultEntity>>((ref) {
  return [];
});

class LoanCollectionGroupScrn extends ConsumerStatefulWidget {
  const LoanCollectionGroupScrn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoanCollectionGroupScrnState();
}

class _LoanCollectionGroupScrnState
    extends ConsumerState<LoanCollectionGroupScrn> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 50), () {
      _refreshdb(ref);
    });
    super.initState();
  }

  bool _isLoading = true;

  Future<void> _refreshdb(WidgetRef ref) async {
    debugPrint("boooollll ::: ${ref.read(isBoolProvider)}");
    if (ref.read(isBoolProvider)) {
      ref.read(isBoolProvider.notifier).state = false;
      if (ref.read(connectivityStatusProviders) ==
          ConnectivityStatus.connected) {
        _isLoading = true;
        ref.read(groupBydataProvider.notifier).update(
              (state) => [],
            );

        await ref.read(loanCollectionListProvider).fold((left) => null,
            (right) async {
          final res = ref.read(moneyCollectionDataSourceProvider);
          // final refresh = ref.read(sqlHelperProvider);
          // await refresh.readAllDataFromDb();
          await res.insertDataToDb(right.result);
          // print("result" + right.result.length.toString());
          var groupBydata = await res.getUniqueGroupNameAndCode();
          ref.read(groupBydataProvider.notifier).update(
                (state) => groupBydata,
              );
          _isLoading = false;
          debugPrint("groupBydata loan collection screen : ${groupBydata.length}");
          setState(() {});
        });
      } else {
        _isLoading = true;
        final res = ref.read(moneyCollectionDataSourceProvider);
        var groupBydata = await res.getUniqueGroupNameAndCode();
        ref.read(groupBydataProvider.notifier).update(
              (state) => groupBydata,
            );
        _isLoading = false;
        setState(() {});
      }
      setState(() {});
    } else {
      _isLoading = true;
      final res = ref.read(moneyCollectionDataSourceProvider);
      var groupBydata = await res.getUniqueGroupNameAndCode();
      ref.read(groupBydataProvider.notifier).update(
            (state) => groupBydata,
          );
      // print("groupBydata loan collection screen : ${groupBydata.length}");
      _isLoading = false;
      setState(() {});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<ResultEntity> data = ref.watch(groupBydataProvider);
    Size size = MediaQuery.of(context).size;
    return generalsession(
      ref: ref,
      child: WillPopScope(
        onWillPop: () async {
          if (ref.read(filterResetProvider) == true) {
            _refreshdb(ref);
            ref.read(filterResetProvider.notifier).state = false;
            ref
                .read(groupCodeControllerProvider.notifier)
                .update((state) => "");

            ref
                .read(groupNameControllerProvider.notifier)
                .update((state) => "");
            ref.read(loanNoControllerProvider.notifier).update((state) => "");

            ref
                .read(borrowerNamecontrollerProvider.notifier)
                .update((state) => "");
            return false;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: ref.read(filterResetProvider)
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                    onPressed: () {
                      if (ref.read(filterResetProvider)) {
                        _refreshdb(ref);
                        ref.read(filterResetProvider.notifier).state = false;
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
                      } else {
                        ref
                            .read(groupCodeControllerProvider.notifier)
                            .update((state) => "");

                        ref
                            .read(groupNameControllerProvider.notifier)
                            .update((state) => "");
                        ref
                            .read(loanNoControllerProvider.notifier)
                            .update((state) => "");

                        ref
                            .read(borrowerNamecontrollerProvider.notifier)
                            .update((state) => "");
                        Navigator.pop(context);
                      }
                    },
                  )
                : null,
            toolbarHeight: size.height * 0.06,
            title: Text(
              "Loan Collection",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
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
          body: _isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: const SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 30.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                        ContentPlaceholder(
                          lineType: ContentLineType.threeLines,
                        ),
                        SizedBox(height: 13.0),
                      ],
                    ),
                  ))
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: Apppadding.p10),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(width: 0.5),
                                      right: BorderSide(width: 0.5))),
                              height: size.height * 0.07,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Group List",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  )),
                            ),
                          ),
                          Container(
                            height: size.height * 0.07,
                            color: Colors.black,
                            width: 0.5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                bottom: BorderSide(width: 0.5),
                              )),
                              width: 100,
                              height: size.height * 0.07,
                              child: InkWell(
                                onTap: () {
                                  GoRouter.of(context)
                                      .pushNamed(Routes.loanFilterScreen);
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(Icons.filter_list),
                                    Text(
                                      "Filter ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                          color: const Color.fromARGB(255, 232, 232, 232),
                          height: size.height * 0.84,
                          width: size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: Apppadding.p10),
                          child: data.isEmpty
                              ? const Center(
                                  child: Text("No Records Found"),
                                )
                              : ScrollConfiguration(
                                  behavior: const ScrollBehavior(),
                                  child: GlowingOverscrollIndicator(
                                    axisDirection: AxisDirection.down,
                                    color: Colors.green,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                          bottom: 30, top: 5),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return data.isEmpty
                                            ? const Column(
                                                children: [
                                                  CircularProgressIndicator(),
                                                  Center(
                                                    child: Text(
                                                        "Searching for data "),
                                                  )
                                                ],
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoanCollectionScreen(
                                                                groupbyData:
                                                                    data[
                                                                        index]),
                                                      ));
                                                },
                                                child: Container(
                                                  height: size.height * 0.15,
                                                  margin: const EdgeInsets.only(
                                                      bottom: Apppadding.p10),
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: Apppadding.p8),
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Material(
                                                    elevation: 20,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .only(
                                                          left: Apppadding.p5,
                                                          top: Apppadding.p5),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              data[index]
                                                                  .groupName!,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          22),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height:
                                                                Apppadding.p5,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              "Group code",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                          ),
                                                          Text(
                                                              data[index]
                                                                      .groupCode ??
                                                                  "error",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                      },
                                    ),
                                  ),
                                ))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class GroupByResult {
  final String groupCode;
  final String groupName;
  GroupByResult({
    required this.groupCode,
    required this.groupName,
  });
}
