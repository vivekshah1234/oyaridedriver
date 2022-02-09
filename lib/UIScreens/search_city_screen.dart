import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/dynamic_extensions.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Models/place_details_model.dart';
import 'package:oyaridedriver/Models/search_location_model.dart';
class SearchCity extends StatefulWidget {
  final callBack;

  SearchCity(this.callBack);

  @override
  State<StatefulWidget> createState() => _SearchState();
}

class _SearchState extends State<SearchCity> {
  final key = GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = TextEditingController();
  bool _isSearching = false;
  String _error = "error";
  List<Predictions> _results = [];

  late Timer debounceTimer;
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }
  _SearchState() {
    _searchQuery.addListener(() {
      // if (debounceTimer != null) {
      //   debounceTimer.cancel();
      // }
      debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          performSearch(_searchQuery.text);
        }
      });
    });
  }

  void performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _error = "";
        _results = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _error = "";
      _results = [];
    });

    final repos = await getSuggestions(query);

    if (this._searchQuery.text == query && this.mounted) {
      setState(() {
        _isSearching = false;
        if (repos != null) {
          _results = repos;
          //printInfo(info: _results[0].description.toString());
        } else {
          _error = 'Error searching repos';
        }
      });
    }
  }

  // final Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: key,
        backgroundColor: AllColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AllColors.whiteColor,
          automaticallyImplyLeading: false,
          leading:  Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: GestureDetector(
                onTap: (){
                  Get.back();
                },

                child: const Icon(Icons.arrow_back_ios,color: AllColors.blackColor,size: 35,)),
          ),titleSpacing: 0,
          centerTitle: false,
          title: TextField(
            autofocus: true,
            focusNode:myFocusNode ,
            controller: _searchQuery,
            cursorColor: Colors.black,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: false,
                // prefixIcon: Icon(
                //   Icons.search,
                //   color: Colors.black,
                // ),
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.black)),
          ),
        ),
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    if (_isSearching) {
      // printInfo(info: "Searching");
      return Center(child: greenLoadingWidget());
    } else {
      //printInfo(info: "else");
      return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _results.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                 final pDetails = await getPlaceDetails(_results[index].placeId);


                 Map<String, dynamic> map={
                   "cityLatitude":pDetails.result.geometry.location.lat,
                   "cityLongitude":pDetails.result.geometry.location.lng,
                   "cityName":pDetails.result.formattedAddress
                 };

                widget.callBack(map);

                Navigator.pop(context, true);
              },
              child: Container(
                padding:
                const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
                child: Text(
                  _results[index].description,
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            );
          });
    }
  }
  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }
}

class CenterTitle extends StatelessWidget {
  final String title;

  const CenterTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          textAlign: TextAlign.center,
        ));
  }
}

getSuggestions(String query) async {
  await Future.delayed(const Duration(seconds: 1));
  try {
    var uri = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=geocode&language=en&key=${ApiKeys.mapApiKey}");
    print("URI==="+uri.toString());
    var response = await http.get(uri);
    Map<String, dynamic> res = json.decode(response.body);
     print(res);
    GoogleSearchModel objData = GoogleSearchModel.fromJson(res);
    List<Predictions>? ra = objData.predictions;
    // print(ra![0].placeId);
    return ra;
  } catch (e) {
    print(e);
    throw Exception('Failed to load post');
  }
}

Future<PlaceDetails> getPlaceDetails(String placeId) async {
  await Future.delayed(const Duration(seconds: 1));
  try {
    var uri = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${ApiKeys.mapApiKey}");
    print("URI2==="+uri.toString());
    var response = await http.get(uri);
    Map<String, dynamic> res = json.decode(response.body);

   PlaceDetails objData = PlaceDetails.fromJson(res);
   // print(objData.result!.name.toString());
    return objData;
  } catch (e) {
    print(e);
    throw Exception('Failed to load post');
  }
}