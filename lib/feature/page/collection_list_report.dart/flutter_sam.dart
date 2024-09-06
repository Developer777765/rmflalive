import 'package:flutter/material.dart';


class CollectionListRepPage extends StatefulWidget {
  const CollectionListRepPage({Key? key}) : super(key: key);

  @override
  _CollectionListRepPageState createState() => _CollectionListRepPageState();
}

class _CollectionListRepPageState extends State<CollectionListRepPage> {
  var list = [
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    "hello",
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text("Test"),
              expandedHeight: 300,
              toolbarHeight: 50,
              backgroundColor: Colors.green,
              pinned: false,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20),
                child: Container(
                  color: Colors.amber,
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: const Center(child: Text("persistent")),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapAbsorber(  
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverPersistentHeader(
                      pinned: true,
                      delegate: _YellowContainerDelegate(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.red,
                      height: 200,
                      width: 100,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          color: Colors.amberAccent,
                          child: ListTile(
                            tileColor: Colors.green,
                            title: Text(
                              list[index].toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      },
                      childCount: list.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _YellowContainerDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.yellow,
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "View Report",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
