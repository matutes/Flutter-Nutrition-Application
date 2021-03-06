//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//import 'package:nutrition_app_flutter/pages/search/details.dart';
//import 'package:nutrition_app_flutter/actions/encrypt.dart';
//import 'package:nutrition_app_flutter/storage/fooditem.dart';
//
//
///// FoodGroupResult displays information regarding Cloud Firestore queries in a list like fashion.
///// FoodGroupResult has a token that specifics the search key, and a type that dictates the type of
///// ListItem displayed.
//class FoodGroupResult extends StatefulWidget {
//  FoodGroupResult({this.foodItemInformation});
//
//  Map<String, dynamic> foodItemInformation;
//
//  @override
//  _FoodGroupResultState createState() =>
//      _FoodGroupResultState(foodItemInformation: foodItemInformation);
//}
//
//class _FoodGroupResultState extends State<FoodGroupResult> {
//  _FoodGroupResultState({this.foodItemInformation});
//
//  Map<String, dynamic> foodItemInformation;
//
//  bool _ready = false;
//  var stream;
//  FirebaseUser currentUser;
//
//  @override
//  void initState() {
//    super.initState();
//    doGathering();
//  }
//
//  /// Care Dairy
//  List<String> _darkgroups = [
//    'Breakfast Cereals',
//    'Dairy and Egg Products',
//    'Fats and Oils',
//    'Lamb, Veal, and Game Products',
//    'Snacks',
//    'Soups, Sauces, and Gravies',
//    'Fruits and Fruit Juices'
//  ];
//
//  /// Gathers the data needed to be displayed on this page before
//  /// the page is 'ready'
//  void doGathering() async {
//    currentUser = await FirebaseAuth.instance.currentUser();
//    stream = Firestore.instance
//        .collection('ABBREV')
//        .where('foodgroup', isEqualTo: foodItemInformation['foodgroup'])
//        .limit(20)
//        .snapshots();
//    _ready = true;
//    if (mounted) {
//      setState(() {});
//    }
//  }
//
//  /// Returns a loading screen widget
//  /// TODO Make this global
//  Widget _buildLoadingScreen() {
//    return new Center(
//      child: new Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.all(12.0),
//            child: CircularProgressIndicator(
//              semanticsValue: 'Progress',
//            ),
//          ),
//          Padding(
//            padding: EdgeInsets.all(12.0),
//            child: Text('Loading...'),
//          )
//        ],
//      ),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (!_ready) {
//      return new Scaffold(
//          appBar: new AppBar(
//            backgroundColor: Colors.transparent,
//          ),
//          body: _buildLoadingScreen());
//    } else {
//      return new Scaffold(
//        body: Container(
//          child: LayoutBuilder(
//              builder: (BuildContext contest, BoxConstraints constraintss) {
//            return SingleChildScrollView(
//              child: ConstrainedBox(
//                constraints: BoxConstraints(minHeight: constraintss.maxHeight),
//                child: new Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    Stack(
//                      children: <Widget>[
//                        new Positioned(
//                            child: Hero(
//                          tag: foodItemInformation,
//                          child: new AspectRatio(
//                            aspectRatio: 16 / 8,
//                            child: new Container(
//                              decoration: new BoxDecoration(
//                                  image: new DecorationImage(
//                                fit: BoxFit.cover,
//                                alignment: FractionalOffset.center,
//                                image: Image.network(foodItemInformation['url'])
//                                    .image,
//                              )),
//                            ),
//                          ),
//                        )),
//                        Padding(
//                          padding: EdgeInsets.only(top: 32.0),
//                          child: new Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Card(
//                                color: Theme.of(context).accentColor,
//                                child: IconButton(
//                                    icon: Icon(Icons.arrow_back, color: Colors.black,),
//                                    onPressed: () {
//                                      Navigator.pop(context);
//                                    }),
//                              )
//                            ],
//                          ),
//                        )
//                      ],
//                    ),
//                    Padding(
//                      padding: EdgeInsets.only(left: 16.0, top: 8.0),
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            foodItemInformation['name'],
//                            style: Theme.of(context).accentTextTheme.headline,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(left: 16.0),
//                      child: Divider(),
//                    ),
//                    Flexible(
//                      child: SizedBox(
//                          child: Padding(
//                              padding:
//                                  EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 4.0),
//                              child: Center(
//                                child: Text(
//                                  foodItemInformation['description'],
//                                ),
//                              ))),
//                    ),
//                    Divider(
//                      color: Colors.transparent,
//                    ),
//                    Container(
//                      margin: const EdgeInsets.only(left: 16.0, top: 6.0),
//                      child: Text(
//                        'Browse Items',
//                        style: Theme.of(context).accentTextTheme.subhead,
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.only(left: 16.0),
//                      child: Divider(),
//                    ),
//                    StreamBuilder<QuerySnapshot>(
//                      stream: stream,
//                      builder: (BuildContext context,
//                          AsyncSnapshot<QuerySnapshot> snapshot) {
//                        if (snapshot.hasError)
//                          return new Text('Error: ${snapshot.error}');
//                        switch (snapshot.connectionState) {
//                          case ConnectionState.waiting:
//                            return _buildLoadingScreen();
//                          default:
//                            return Column(
//                              children: snapshot.data.documents
//                                  .map((DocumentSnapshot document) {
//                                return new ListItem(
//                                  foodItem: new FoodItem(document),
//                                );
//                              }).toList(),
//                            );
//                        }
//                      },
//                    )
//                  ],
//                ),
//              ),
//            );
//          }),
//        ),
//      );
//    }
//  }
//}
//
///// ListItem is a special ListTile that navigates to a new page of nutrition information on pressed.
//class ListItem extends StatefulWidget {
//  ListItem({this.foodItem});
//
//  FoodItem foodItem;
//
//  @override
//  State<StatefulWidget> createState() => new _ItemView(foodItem: foodItem);
//}
//
//class _ItemView extends State<ListItem> {
//  _ItemView({this.foodItem});
//
//  FoodItem foodItem;
//  FirebaseUser currentUser;
//  bool isFavorited;
//  bool _ready = false;
//
//  @override
//  void initState() {
//    super.initState();
//    gatherData();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    gatherData();
//  }
//
//  void gatherData() async {
//    currentUser = await FirebaseAuth.instance.currentUser();
//    if (currentUser.isAnonymous) {
//      isFavorited = false;
//    } else {
//      QuerySnapshot item = await Firestore.instance
//          .collection('USERS')
//          .document(Encrypt().encrypt(currentUser.email))
//          .collection('NUTRIENTS')
//          .where('description',
//              isEqualTo: foodItem.detailItems['description']['value'])
//          .getDocuments();
//      if (item.documents.length == 0) {
//        isFavorited = false;
//      } else {
//        isFavorited = true;
//      }
//    }
//    _ready = true;
//    if (mounted) {
//      this.setState(() {});
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return (_ready)
//        ? Container(
//            height: 70.0,
//            child: new Card(
//              child: new ListTile(
//                onTap: () async {
//                  /// onTap(): Navigate to a new Details page
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (context) => FoodGroupDetails(
////                                foodItem: widget.foodItem,
//                              )));
//                },
//                title: Align(
//                  alignment: Alignment.centerLeft,
//                  child: Text(
//                    foodItem.detailItems['description']['value'],
//                    maxLines: 1,
//                    overflow: TextOverflow.ellipsis,
//                    style: Theme.of(context).accentTextTheme.body1,
//                  ),
//                ),
//                trailing: new IconButton(
//                    splashColor: (!isFavorited) ? Colors.amber : Colors.black12,
//                    icon: (!isFavorited)
//                        ? Icon(
//                            Icons.favorite_border,
//                            color: Colors.grey,
//                          )
//                        : Icon(
//                            Icons.favorite,
//                            color: Colors.amber,
//                          ),
//                    onPressed: () async {
//                      /// Checking to see if a user can favorite an item or not
//                      /// If not, displays a snackbar
//                      if (currentUser.isAnonymous) {
//                        final snackbar = SnackBar(
//                          content: Text(
//                            'You must register before you can do that!',
//                          ),
//                          duration: Duration(milliseconds: 1500),
//                        );
//                        Scaffold.of(context).showSnackBar(snackbar);
//                      }
//
//                      /// If applicable, update the user's data in Cloud Firestore.
//                      ///
//                      /// Remove from Firestore
//                      if (isFavorited && !currentUser.isAnonymous) {
//                        isFavorited = false;
//                        if (mounted) {
//                          setState(() {});
//                        }
//                        await Firestore.instance
//                            .collection("USERS")
//                            .document(Encrypt().encrypt(currentUser.email))
//                            .collection('NUTRIENTS')
//                            .document(
//                                foodItem.detailItems['description']['value'])
//                            .delete();
//                      }
//
//                      /// Add to Firestore
//                      else if (!isFavorited && !currentUser.isAnonymous) {
//                        isFavorited = true;
//                        if (mounted) {
//                          setState(() {});
//                        }
//                        await Firestore.instance
//                            .collection("USERS")
//                            .document(Encrypt().encrypt(currentUser.email))
//                            .collection('NUTRIENTS')
//                            .document(
//                                foodItem.detailItems['description']['value'])
//                            .setData(foodItem.toFirestore());
//                      }
//                    }),
//              ),
//            ),
//          )
//        : Text('');
//  }
//}
//
///// Splash Screen
///// TODO Make a global splash screen
//class SplashScreenAuth extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: CircularProgressIndicator(),
//    );
//  }
//}
