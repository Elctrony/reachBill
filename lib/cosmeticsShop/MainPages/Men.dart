import 'package:flutter/material.dart';
import '../MainItemHelper.dart';

class Men extends StatefulWidget {
  @override
  _MenState createState() => _MenState();
}

class _MenState extends State<Men> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
          onPressed: ()=>Navigator.pop(context),
        ),
        title: Container(
          alignment: Alignment.centerRight,
          child: Text("مستحضرات تجميل رجالي",style: TextStyle(
            color: Colors.teal.shade600,fontSize: 16,fontWeight: FontWeight.w700
          ),textAlign: TextAlign.right,),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: Icon(Icons.search,size: 30,color: Colors.black54,),
                          onPressed: (){
                            print("search pressed");
                          }
                        ),
                        border: InputBorder.none,
                        //filled: true,
                        hintText: "بحث",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        fillColor:Colors.white,alignLabelWithHint: true
                      ),
                      textCapitalization: TextCapitalization.words,
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      style: TextStyle(fontSize: 15,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: MainItems(categoryId: 1,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
