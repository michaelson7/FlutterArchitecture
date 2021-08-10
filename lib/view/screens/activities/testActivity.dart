import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/IncrementallyLoadingListView.dart';

class TestActivity extends StatefulWidget {
  static String id = "TestActivity";
  @override
  _TestActivityState createState() => new _TestActivityState();
}

class _TestActivityState extends State<TestActivity> {
  late List<Item> items;
  bool? _loadingMore;
  late bool _hasMoreItems;
  int _maxItems = 30;
  int _numItemsPage = 10;
  Future? _initialLoad;

  Future _loadMoreItems() async {
    final totalItems = items.length;
    await Future.delayed(Duration(seconds: 3), () {
      for (var i = 0; i < _numItemsPage; i++) {
        items.add(Item('Item ${totalItems + i + 1}'));
      }
    });

    _hasMoreItems = items.length < _maxItems;
  }

  @override
  void initState() {
    super.initState();
    _initialLoad = Future.delayed(Duration(seconds: 3), () {
      // List items = [];
      items = <Item>[];
      for (var i = 0; i < _numItemsPage; i++) {
        items.add(Item('Item ${i + 1}'));
      }
      _hasMoreItems = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      body: SafeArea(
        child: FutureBuilder(
          future: _initialLoad,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return IncrementallyLoadingListView(
                  hasMore: () => _hasMoreItems,
                  itemCount: () => items.length,
                  loadMore: () async {
                    // can shorten to "loadMore: _loadMoreItems" but this syntax is used to demonstrate that
                    // functions with parameters can also be invoked if needed
                    print('loading');
                    await _loadMoreItems();
                  },
                  onLoadMore: () {
                    setState(() {
                      _loadingMore = true;
                    });
                  },
                  onLoadMoreFinished: () {
                    setState(() {
                      _loadingMore = false;
                    });
                  },
                  separatorBuilder: (_, __) => Divider(),
                  loadMoreOffsetFromBottom: 2,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    if ((_loadingMore ?? false) && index == items.length - 1) {
                      return Column(
                        children: <Widget>[
                          ItemCard(item: item),
                          PlaceholderItemCard(item: item),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        ItemCard(item: item),
                      ],
                    );
                  },
                );
              default:
                return Text('Something went wrong');
            }
          },
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(item.avatarUrl),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                      child: Text(item.name),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(item.message),
              )
            ],
          ),
        ),
      ),
      onTap: () => {},
    );
  }
}

class PlaceholderItemCard extends StatelessWidget {
  const PlaceholderItemCard({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 60.0,
                    height: 60.0,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                    child: Container(
                      color: Colors.white,
                      child: Text(
                        item.name,
                        style: TextStyle(color: Colors.transparent),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Container(
                  color: Colors.white,
                  child: Text(
                    item.message,
                    style: TextStyle(color: Colors.transparent),
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

class Item {
  final String name;
  final String avatarUrl = 'http://via.placeholder.com/60x60';
  final String message =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  Item(this.name);
}
