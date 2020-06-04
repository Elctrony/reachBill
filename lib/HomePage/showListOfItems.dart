import 'package:flutter/material.dart';
import '../main.dart';

class ShowListOfItems extends StatelessWidget {

  List dataFromApi;
  ShowListOfItems({this.dataFromApi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width,
            childAspectRatio: 3/1,
          ),
          shrinkWrap: true,
          physics: ScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: dataFromApi.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(left: 8,right: 8,top: 6,bottom: 6),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(7),
                          topLeft: Radius.circular(7),
                          bottomRight: Radius.circular(0),
                          topRight: Radius.circular(0),
                        ),
                      ),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 8),
                                child: Text(dataFromApi[index]["name"],
                                  style: TextStyle(color: Colors.teal.shade700,fontSize: 22),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 8),
                                child: Text(dataFromApi[index]["description"],
                                  style: TextStyle(color: Colors.teal,fontSize: 18),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(height: 1,),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      padding: EdgeInsets.only(right: 8),
                                      child: Text(" ${dataFromApi[index]["price"]} LE ",
                                        style: TextStyle(color: Colors.teal,fontSize: 16),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.all(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0),
                          topLeft: Radius.circular(0),
                          bottomRight: Radius.circular(7),
                          topRight: Radius.circular(7),
                        ),
                      ),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            topLeft: Radius.circular(0),
                            bottomRight: Radius.circular(7),
                            topRight: Radius.circular(7),
                          ),
                          child: Image(image: NetworkImage(
                            getUrl("/images/${dataFromApi[index]["image"]}"),
                            scale: 1,),fit: BoxFit.cover,width: 220,height: 220,),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}
