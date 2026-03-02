import 'package:flutter/material.dart';

class Followed_Author_Card extends StatelessWidget {
  final String item;
  final Animation<double> animation;
  final VoidCallback onClicked;

  const Followed_Author_Card({
    super.key,
    required this.item,
    required this.animation,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) =>
      SizeTransition(sizeFactor: animation, child: buildItem(context));
  Widget buildItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(item),
        trailing: IconButton(onPressed: onClicked, icon: Icon(Icons.remove)),
      ),
    );
  }
}
