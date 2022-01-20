import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as poly_util;
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/notificationScreen.dart';
import 'package:oyaridedriver/Common/common_methods.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';
import 'package:oyaridedriver/UIScreens/drawer_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/extension_widgets.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:oyaridedriver/UIScreens/rider_details_screen.dart';
import 'package:oyaridedriver/UIScreens/rider_list_cart_screen.dart';
import 'package:sized_context/src/extensions.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:timelines/timelines.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
// ignore_for_file: prefer_const_constructors

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({Key? key}) : super(key: key);

  @override
  _MapHomeScreenState createState() => _MapHomeScreenState();
}

bool isAccepted = false;

class _MapHomeScreenState extends State<MapHomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late double latitude, longitude;
  late CameraPosition _kGooglePlex;
  late LatLng _lastMapPosition;
  bool isOnline = false;
  bool isLoading = true;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLine = <Polyline>{};
  List<LatLng> polyLineCoordinates = [];
  late PolylinePoints polylinePoints;
  int status = -1;
  final List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  List<Map<String, dynamic>> dataList = [
    {
      "name": "Ian Somerholder",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College",
      "route": DummyData.route1,
      "sourceLatLong": LatLng(22.9960, 72.4997),
      "destinationLatLong": LatLng(23.0585, 72.5175),
    },
    {
      "name": "Paul Welsey",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College",
      "route": DummyData.route2,
      "sourceLatLong": LatLng(22.9960, 72.4997),
      "destinationLatLong": LatLng(23.0145, 72.5929),
    },
    {
      "name": "Nina Doberev",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College",
      "route": DummyData.route1,
      "sourceLatLong": LatLng(22.9960, 72.4997),
      "destinationLatLong": LatLng(23.0585, 72.5175),
    },
    {
      "name": "Tony Somerholder",
      "imgUrl": imgUrl,
      "charge": 50.0,
      "kiloMeter": 15.0,
      "sourcePoint": "Medical Education Center",
      "destinationPoint": "Barthimam College",
      "route": DummyData.route2,
      "sourceLatLong": LatLng(22.9960, 72.4997),
      "destinationLatLong": LatLng(23.0145, 72.5929),
    }
  ];

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    init();
    //   setPolyline();
  }

  init() {
    for (int i = 0; i < dataList.length; i++) {
      _swipeItems.add(SwipeItem(
          content: Content(
              name: dataList[i]["name"],
              imgurl: dataList[i]["imgUrl"],
              charge: dataList[i]["charge"],
              kiloMeter: dataList[i]["kiloMeter"],
              pickUpPoint: dataList[i]["sourcePoint"],
              destinationPoint: dataList[i]["destinationPoint"]),
          likeAction: () {
            printInfo(info: "like");
            acceptRequest(i);
          },
          nopeAction: () {
            setMarker(
                source: dataList[i + 1]["sourceLatLong"],
                destination: dataList[i + 1]["destinationLatLong"]);
            setPolyline(dataList[i + 1]["route"]);
            printInfo(info: "nope");
          },
          superlikeAction: () {
            printInfo(info: "super Like");
          }));
    }
    polylinePoints = PolylinePoints();
    setMarker(
        source: dataList[0]["sourceLatLong"],
        destination: dataList[0]["destinationLatLong"]);
    setPolyline(dataList[0]["route"]);

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  getCurrentPosition() async {
    Position position = await determinePosition();
    latitude = position.latitude;
    longitude = position.longitude;
    _lastMapPosition = LatLng(latitude, longitude);
    _kGooglePlex = CameraPosition(
      target: _lastMapPosition,
      zoom: 14.4746,
    );

    isLoading = false;
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      drawer: DrawerScreen(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: FloatingActionButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            backgroundColor: AllColors.whiteColor,
            child: const Icon(
              Icons.sort,
              color: AllColors.blackColor,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => NotificationScreen());
              },
              child: CircleAvatar(
                backgroundColor: AllColors.whiteColor,
                child: const Icon(
                  Icons.notifications_none_sharp,
                  size: 30,
                  color: AllColors.blackColor,
                ),
              ),
            ),
          ),
          !isOnline
              ? GestureDetector(
                  onTap: () {
                    isOnline = !isOnline;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AllColors.blackColor,
                        borderRadius: BorderRadius.circular(13)),
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AllColors.whiteColor,
                          radius: 7,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        textWidget(
                            txt: " Go online ",
                            fontSize: 11,
                            color: AllColors.whiteColor,
                            italic: false,
                            bold: FontWeight.w600)
                      ],
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    isOnline = !isOnline;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: AllColors.blackColor,
                        borderRadius: BorderRadius.circular(13)),
                    margin: const EdgeInsets.only(top: 15, bottom: 15),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      children: [
                        textWidget(
                            txt: " Go offline",
                            fontSize: 11,
                            color: AllColors.whiteColor,
                            italic: false,
                            bold: FontWeight.w600),
                        const SizedBox(
                          width: 7,
                        ),
                        CircleAvatar(
                          backgroundColor: AllColors.greenColor,
                          radius: 7,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                      ],
                    ),
                  ),
                ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(
        children: [
          isLoading
              ? SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: greenLoadingWidget(),
                )
              : GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                  polylines: _polyLine,
                ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: status == -1
                ? SizedBox(
                    height: calculateHeight(
                        MediaQuery.of(context).size.height, context),
                    child: SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              Get.to(() => const RiderDetailScreen());
                            },
                            child: SwipeItem2(
                              name: dataList[index]["name"],
                              imgUrl: dataList[index]["imgUrl"],
                              km: dataList[index]["kiloMeter"],
                              price: dataList[index]["charge"],
                              pickUpPoint: dataList[index]["sourcePoint"],
                              dropOffPoint: dataList[index]["destinationPoint"],
                              acceptOnTap: () {
                                _matchEngine.currentItem?.like();
                                acceptRequest(index);
                                setState(() {});
                              },
                              ignoreOnTap: () {
                                printInfo(info: "aaaaa");
                                _matchEngine.currentItem?.nope();
                                if (index != dataList.length - 1) {
                                  setMarker(
                                      source: dataList[index + 1]
                                          ["sourceLatLong"],
                                      destination: dataList[index + 1]
                                          ["destinationLatLong"]);
                                  setPolyline(dataList[index + 1]["route"]);
                                }
                                setState(() {});
                              },
                            ));
                      },
                      onStackFinished: () {
                        _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                          content: Text("Stack Finished"),
                          duration: Duration(milliseconds: 500),
                        ));

                        polyLineCoordinates.clear();
                        _polyLine.clear();
                        _markers.clear();
                        setState(() {});
                      },
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AllColors.whiteColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),

                    //  padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        locationDetails(),
                        status < 2
                            ? RiderDetails(
                                name: "Stella Josh",
                                callButton: () {
                                  url_launcher.launch("tel://21213123123");
                                },
                              )
                            : status == 2
                                ? whileTravelingCart()
                                : userCart3(),
                        status < 2
                            ? Row(
                                children: [
                                  SmallButton(
                                    text: "CANCEL",
                                    color: AllColors.blueColor,
                                    onPressed: () {
                                      printInfo(info: "************stop***********");
                                      _locationSubscription?.cancel();
                                     // _locationTracker.
                                      setState(() {
                                        _locationSubscription = null;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  if (status < 1)
                                    SmallButton(
                                      text: "ARRIVED",
                                      color: AllColors.greenColor,
                                      onPressed: () {
                                        status = 1;
                                        print("tap");
                                        setState(() {});
                                      },
                                    )
                                  else if (status == 1)
                                    SmallButton(
                                      text: "PICKED UP",
                                      color: AllColors.greenColor,
                                      onPressed: () {
                                        status = 2;
                                        print("tap");
                                        setState(() {});
                                      },
                                    )
                                  else if (status == 2)
                                    Container()
                                  // Expanded(child: greenButton(txt: "ACCEPT",function: (){})),
                                ],
                              ).putPadding(
                                0,
                                20,
                                context.widthPct(0.08),
                                context.widthPct(0.08),
                              )
                            : status == 2
                                ? AppButton(
                                        text: "TAP WHEN DROP",
                                        onPressed: () {
                                          status = 3;
                                          print("tap");
                                          setState(() {});
                                        },
                                        color: AllColors.greenColor)
                                    .paddingSymmetric(horizontal: 15)
                                : AppButton(
                                        text: "CONFIRM PAYMENT",
                                        onPressed: () {
                                          status = 4;
                                          print("tap");
                                          setState(() {});
                                        },
                                        color: AllColors.greenColor)
                                    .paddingSymmetric(horizontal: 15),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  acceptRequest(i) {
    status = 0;
    startLiveTracking();
    setState(() {});
  }

  setPolyline(route) async {
    polyLineCoordinates.clear();
    _polyLine.clear();
    var points = poly_util.PolygonUtil.decode(route);
    for (var pointLatLng in points) {
      polyLineCoordinates
          .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    }

    _polyLine.add(Polyline(
        polylineId: PolylineId("poly"),
        color: AllColors.blueColor,
        width: 4,
        points: polyLineCoordinates));
    setState(() {});
  }

  setMarker({required LatLng source, required LatLng destination}) async {
    _markers.clear();
    Uint8List? imageData =
        await getBytesFromAsset(ImageAssets.greenLocationPin, 100);
    _markers.add(Marker(
        markerId: MarkerId("markerSource"),
        position: source,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(imageData!)));
    _markers.add(Marker(
        markerId: MarkerId("markerDestination"),
        position: destination,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.defaultMarker));

    getBounds(_markers);
    setState(() {});
  }



  void updateMarkerAndCircle(var newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData)));
    });
  }

  StreamSubscription<LocationData>? _locationSubscription;

  final Location _locationTracker = Location();
  startLiveTracking() async {
    try {
      var location = await determinePosition();
      _lastMapPosition = LatLng(location.latitude, location.longitude);
      Uint8List? imageData = await getBytesFromAsset(ImageAssets.driverCarIcon,100);

      _locationSubscription =
          _locationTracker.onLocationChanged.handleError((onError) {
            print(onError);
            _locationSubscription?.cancel();
            setState(() {
              _locationSubscription = null;
            });
          }).listen((newLocalData) async {
            if (_controller != null) {
              final GoogleMapController controller = await _controller.future;
              _lastMapPosition =
                  LatLng(newLocalData.latitude!, newLocalData.longitude!);
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      bearing: 192.833,
                      target: _lastMapPosition,
                      tilt: 0,
                      zoom: 12)));

              updateMarkerAndCircle(newLocalData, imageData!);
            }
          });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Widget locationDetails() {
    return Container(
      decoration: const BoxDecoration(
        color: AllColors.blackColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 20, right: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                status == 0 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.location_on,
              color: AllColors.blackColor,
            ),
          ),
          Expanded(child: dottedLine()),
          CircleAvatar(
            backgroundColor:
                status <= 1 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.directions_car,
              color: AllColors.blackColor,
            ),
          ),
          Expanded(child: dottedLine2()),
          CircleAvatar(
            backgroundColor:
                status <= 2 ? AllColors.whiteColor : AllColors.greenColor,
            child: const Icon(
              Icons.flag_sharp,
              color: AllColors.blackColor,
            ),
          )
        ],
      ),
    );
  }

  Widget dottedLine() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: status <= 1 ? AllColors.whiteColor : AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget dottedLine2() {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 4.0,
      dashColor: status <= 2 ? AllColors.whiteColor : AllColors.greenColor,
      // dashGradient: const [Colors.red, Colors.blue],
      dashRadius: 0.0,
      dashGapLength: 4.0,
      dashGapColor: Colors.transparent,
      //  dashGapGradient: const [Colors.red, Colors.blue],
      dashGapRadius: 0.0,
    );
  }

  Widget whileTravelingCart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //  crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            shadowColor: Colors.grey.shade900,
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://i.pinimg.com/564x/04/e1/78/04e1784fc85d72ccec586ca224ce361a.jpg"),
                  radius: 35,
                ).putPadding(10, 10, 25, 25),
                // SizedBox(height: 10,),
                textWidget(
                    txt: "Stella Josan",
                    bold: FontWeight.w600,
                    fontSize: 18,
                    italic: false,
                    color: AllColors.blackColor),
                const SizedBox(
                  height: 10,
                ),
                GiveRatingWidget(initialRating: 3, onRatingUpdate: (val) {})
              ],
            ).putPadding(20, 20, 20, 20),
          ),
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              shadowColor: Colors.grey.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      txt: "Waiting",
                      bold: FontWeight.w500,
                      fontSize: 18,
                      italic: false,
                      color: AllColors.blackColor),
                  const SizedBox(
                    height: 10,
                  ),
                  textWidget(
                      txt: "00:00:00",
                      bold: FontWeight.w500,
                      fontSize: 18,
                      italic: false,
                      color: AllColors.blackColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userCart3() {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade50,
          padding: const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(imgUrl),
                    radius: 35,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  textWidget(
                      txt: "Stella Josan",
                      bold: FontWeight.w800,
                      fontSize: 18,
                      italic: false,
                      color: AllColors.blackColor),
                ],
              ),
              Column(
                children: [
                  textWidget(
                      txt: "\$50",
                      fontSize: 17,
                      color: AllColors.blackColor,
                      bold: FontWeight.w800,
                      italic: false),
                  textWidget(
                      txt: "15 km",
                      fontSize: 15,
                      color: AllColors.greyColor,
                      bold: FontWeight.normal,
                      italic: false),
                ],
              )
            ],
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Booking ID",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false),
                textWidget(
                    txt: "#TXN67876",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Total",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false),
                textWidget(
                    txt: "\$50",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                    txt: "Payment",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false),
                textWidget(
                    txt: "Cash",
                    fontSize: 18,
                    color: AllColors.blackColor,
                    bold: FontWeight.w300,
                    italic: false)
              ],
            ).putPadding(0, 0, 10, 10),
            const SizedBox(
              height: 12,
            ),
            const Divider(
              height: 2,
              color: AllColors.greyColor,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ).putPadding(10, 10, 10, 10),
      ],
    );
  }

  @override
  void dispose() {
    printInfo(info: "dispose============");

    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final GoogleMapController controller = await _controller.future;

      controller.setMapStyle("[]");
    }
  }
}
