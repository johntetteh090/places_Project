import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService{

  final String key = "AIzaSyDby5KQQy-hlSFh1M12wJkXtH5v-U3ochw";

  Future<String> getPlacesId (String input) async{

    //final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?input=$input&inputtype=textquery&key=$key';
    final String url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key";


    //url= Uri.https(url);
    var response = await http.get(Uri.parse(url));

    var json =convert.jsonDecode(response.body);


    var placeId = json['candidates'][0]['place_id'] as String;
    
    //print(placeId);


    return placeId;
    }

  Future<Map<String, dynamic>> getPlaces (String input) async{

    final placeId = await getPlacesId(input);
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';

    var response = await http.get(Uri.parse(url));

    var json =convert.jsonDecode(response.body);


    var results = json['result'] as Map<String,dynamic>;

    return results;

  }
}