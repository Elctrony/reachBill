import 'package:flutter/material.dart';
import '../main.dart';
import './ShowPackageData.dart';

class PackagePage extends StatelessWidget {

  List packages;
  BuildContext context;
  PackagePage({this.packages,this.context});


  onTapFunction(int packageId)async{
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=> ShowPackageData(
      url:getUrl("/api/getpackagedata/$packageId"),)));
  }


  @override
  Widget build(BuildContext context) {
    return packages.length!=0?GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: MediaQuery.of(context).size.width/2,
              childAspectRatio: 5/3,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: packages.length,
      itemBuilder: (BuildContext context,int i){
        return Container(
          child: InkWell(
            onTap: (){
              onTapFunction(packages[i]["id"]);
            },
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width/2-20,
              child: Card(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(image: NetworkImage(
                        getUrl("/images/${packages[i]["image"]}"),scale: 1.0),
                        fit: BoxFit.cover
                    ),
                  )
              ),
            ),
          ),
        );
      },
    ):SizedBox(height: 100,);
  }
}