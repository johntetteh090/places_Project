import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key,required this.searchText,
    required this.image,
    required this.address,
    required this.desc}) : super(key: key);

  final String searchText,
  image,
  address,
  desc;


  @override
  State<DetailsPage> createState() => _DetailsPageState(this.searchText,
      this.image,
      this.address,
      this.desc);
}

class _DetailsPageState extends State<DetailsPage> {

  String searchText,
      image,
      address,
      desc;
   _DetailsPageState(this.searchText,
      this.image,
      this.address,
      this.desc);
  @override
  Widget build(BuildContext context) {
    return  Placeholder(
      color: Colors.black38,
      strokeWidth: 2.0,
      child: Scaffold(
        backgroundColor: CupertinoColors.label,
        appBar: AppBar(
          backgroundColor: CupertinoColors.label,
          elevation: 0.0,
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back,color: Colors.white,),

          ),
          title: Text(searchText,
          style: const TextStyle(color: Colors.white),),
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              //THE IMAGES

              Container(
                height: MediaQuery.of(context).size.height/3,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(image),
              ),
              /*Container(
                height: MediaQuery.of(context).size.height/3,
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.network(image),
              ),*/


             const SizedBox(height: 10.0,),

               Row(
                children: [

                  Container(margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: const Icon(Icons.location_on,color: Colors.white,)),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 15.0,left: 3.0),
                      child:  Text(address,
                        style: const TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w300),),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10.0,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(desc,
                  style: const TextStyle(color: Colors.white,fontSize: 18.0,fontWeight: FontWeight.w300),),
              ),
            ],
          ),
        )
      ),
    );
  }
}
