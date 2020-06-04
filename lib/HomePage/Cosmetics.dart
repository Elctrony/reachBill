import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cosmetics extends StatelessWidget {

  String title;
  String image;
  Function function;
  Color color;
  bool isImage;
  Cosmetics({this.title,this.image,this.function,this.color,this.isImage = true});

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: InkWell(
        onTap: function,
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: 100,
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
                  color: color!=null?color:Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    //padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(image: AssetImage(image),
                        color: !isImage?Colors.white:null,
                        fit: !isImage? BoxFit.scaleDown: BoxFit.cover,
                      ),
                    ),
                  )
              ),
            ),
            Text(title,style: TextStyle(fontSize: 14,
                color: Colors.grey.shade700),)
          ],
        ),
      ),
    );
  }
}
