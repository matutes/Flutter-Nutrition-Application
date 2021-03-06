import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_app_flutter/pages/recipe/details.dart';
import 'package:nutrition_app_flutter/storage/usercache.dart';

class RecipeListTile extends StatefulWidget {
  RecipeListTile({this.ds, this.userCache});

  final DocumentSnapshot ds;
  final UserCache userCache;

  @override
  _RecipeListTileState createState() => _RecipeListTileState();
}

class _RecipeListTileState extends State<RecipeListTile> {
  Image _image;
  bool _loading;

  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();

    _isFavorited = widget.userCache.isInFavoriteRecipes(widget.ds['name']);

    _image = new Image.network(widget.ds['image']);
    _loading = true;
    _image.image.resolve(new ImageConfiguration()).addListener((_, __) async {
      _loading = false;
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 0.0,
      child: Center(
        child: new ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecipeDetails(
                          recipeItem: widget.ds,
                          type: 'browse',
                          userCache: widget.userCache,
                        ))).then((dynamic d) {
              _isFavorited = widget.userCache.isInFavoriteRecipes(widget.ds['name']);
              setState(() {

              });
            });
          },
          leading: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(64, 64)),
            child: AspectRatio(
              aspectRatio: 1,
              child: (_loading)
                  ? Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Hero(
                      tag: widget.ds['name'],
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          widget.ds['image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )),
            ),
          ),
          title: Text(
            widget.ds['name'],
            style: Theme.of(context).accentTextTheme.title,
          ),
          subtitle: Text(
            widget.ds['subcategory'],
            maxLines: 3,
          ),
          trailing: IconButton(
              icon: (_isFavorited)
                  ? Icon(
                      Icons.favorite,
                      color: Colors.amber,
                    )
                  : Icon(Icons.favorite_border),
              onPressed: () async {
                FirebaseUser currentUser =
                    await FirebaseAuth.instance.currentUser();

                if (currentUser.isAnonymous) {
                  final snackbar = SnackBar(
                    content: Text(
                      'You must register before you can do that!',
                    ),
                    duration: Duration(milliseconds: 1500),
                  );
//                    Scaffold.of(context).showSnackBar(snackbar);
                }

                if (_isFavorited && !currentUser.isAnonymous) {
                  widget.userCache.removeFromFavoriteRecipes(widget.ds['name']);
                  if (mounted) {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                  }
                } else if (!_isFavorited && !currentUser.isAnonymous) {
                  widget.userCache.addToFavoriteRecipes(widget.ds.data);
                  if (mounted) {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                  }
                }
              }),
          contentPadding: EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
