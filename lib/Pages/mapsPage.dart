import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:turing_test_project/Pages/detailsPage.dart';
import 'package:turing_test_project/location_service.dart';


class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {


  Set<Marker>_markers = Set<Marker>();
  var Mimage = '';


  var   Mdesc = '';

  var Maddres= '';

  TextEditingController textCon =  TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    //target: LatLng(37.42796133580664, -122.085749655962),
    target: LatLng( 50.033333, 8.570556),
    zoom: 14.4746,
  );

  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer<GoogleMapController>();

  var visible=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setMarker(
        //LatLng(37.42796133580664, -122.085749655962)
          LatLng( 50.033333, 8.570556),
    );
  }

  void _setMarker(LatLng point){

    setState(() {
      _markers.add(
        Marker(markerId: MarkerId('markerId'),position: point,onTap: (){
          visible=true;
        })
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Placeholder(
      color: Colors.black38,
      strokeWidth: 2.0,
      child: Scaffold(
        backgroundColor: CupertinoColors.label,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [

                //THE MAP WIDGET
                GoogleMap(
                  mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller){

                    _controllerGoogleMap.complete(controller);
                    },
                  markers: _markers,

                  onTap: (LatLng lng){
                    setState(() {
                      visible=false;
                    });
                  },
                ),


                Column(
                  children: [

                    const SizedBox(height: 10.0,),
                    //THE SEARCH BAR
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.white70),
                        onSubmitted: (value) async {
                          //print(value);
                          var place = await LocationService().getPlaces(value);
                          _goToPlaces(place);
                        },

                        controller: textCon,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black54,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18.0,),

                    //THE IMAGE,DESCRIPTION AND ADDRESS
                    Visibility(
                      visible: visible,
                        child: Card(
                         color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10.0,),
                              Container(
                                height: 120.0,
                                width: MediaQuery.of(context).size.width/2,

                                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(Mimage,fit: BoxFit.contain,)),
                              ),
                             const SizedBox(height: 8.0,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width/2.5,
                                //margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(Maddres,
                                style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,),
                              ),
                              const SizedBox(height: 8.0,),
                              SizedBox(
                                  //margin: const EdgeInsets.symmetric(horizontal: 15.0),
                                  width: MediaQuery.of(context).size.width/2.5,
                                  child: Text(Mdesc,
                                  overflow: TextOverflow.ellipsis,)
                              ),
                              TextButton(
                                  onPressed: (){

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context)=> DetailsPage(
                                          searchText: textCon.toString(),
                                          image: Mimage,
                                            address: Maddres,
                                          desc:Mdesc
                                        ))
                                    );
                                  },
                                  child: const Text('Details',
                                  style: TextStyle(color: Colors.blue,fontSize: 18.0),)
                              )
                            ],
                          ),
                        )
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),

    );
  }

  Future<void> _goToPlaces(Map<String,dynamic>place) async {

    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final String image = place['icon'];
    final description = place['name'];
    final formattedAddress = place['formatted_address'];

    final GoogleMapController controller = await _controllerGoogleMap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat,lng),zoom: 12)
    ));

    setState(() {
      Mimage = image;
      Mdesc = description;
      Maddres = formattedAddress;
    });
    _setMarker(LatLng(lat, lng));
  }
}
