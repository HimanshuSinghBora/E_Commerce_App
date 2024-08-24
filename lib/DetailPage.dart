import 'dart:convert';

import 'package:e_commerce/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

Map? mapResponse;
List? listResponse;
List? imageResponse;
class DetailPage extends StatefulWidget{
  int index;
  DetailPage({super.key, required this.index});


  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future getProductsApi () async {
    http.Response response;
    response = await http.get(Uri.parse('https://dummyjson.com/products'));
    if(response.statusCode==200){
      setState(() {
        mapResponse = json.decode(response.body);
        listResponse = mapResponse!["products"];
        if(listResponse!=null){
        imageResponse = listResponse![widget.index]["images"];}
        else{
          CircularProgressIndicator();
        }
      });
    }
  }
  void initState(){
    getProductsApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // if (listResponse == null) {
    //   return const Center(
    //     child: Padding(
    //       padding: EdgeInsets.all(30),
    //       child: CircularProgressIndicator(
    //       ),
    //     ),
    //   );
    // }
    return Scaffold(
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Container(
                        alignment: Alignment.topLeft,child: Icon(Icons.arrow_back_ios_rounded,size: 30,)),
                  onTap: (){
                      Navigator.pop(context);
                  },),
                  Container(
                      alignment: Alignment.center,child:listResponse==null?Container(): Text(listResponse![widget.index]["title"],style: TextStyle(fontSize: 30),)),
                  Container(alignment: Alignment.centerRight,child: Icon(Icons.share,size: 30,)),
                ],
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
              height: 450,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  itemCount:imageResponse==null? 0 :imageResponse!.length,
                  itemBuilder: (context, index){
                  return Image.network(imageResponse![index]);
                }
                ),
                      ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(child:listResponse==null?Container(
                      ): Text(listResponse![widget.index]['brand']==null?"":listResponse![widget.index]['brand'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                      Container(child: listResponse==null?Container():Text("\$"+listResponse![widget.index]['price'].toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                  Container(
                    child: listResponse==null?Container():Text(listResponse![widget.index]['description'],style: TextStyle(fontSize: 20),),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: ElevatedButton(onPressed: (){

                    }, child: Text("Add To Cart",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.blue),)),
                  )
                ],
              ),
            )
            ],
          ),
            //     Text("Title:"+listResponse![widget.index]['title'],textAlign: TextAlign.end,),
            //     Text("Prize:"+listResponse![widget.index]["price"].toString()),
            //     Text("Description:"+listResponse![widget.index]['description']),
            ),
        ),
    ),
    );
  }
}