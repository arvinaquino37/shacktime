import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrm_app/data/server/respository/repository.dart';
import 'package:hrm_app/live_traking/common_method.dart';
import 'package:hrm_app/live_traking/hive/driver_location_provider.dart';
import 'package:hrm_app/live_traking/services/location_service.dart';
import 'package:hrm_app/live_traking/services/geolocator_service.dart';
import 'package:hrm_app/utils/app_const.dart';
import 'package:hrm_app/utils/shared_preferences.dart';
import 'package:location/location.dart';

import 'hive/driver_location_model.dart';

class LocationProvider extends ChangeNotifier {
  LocationService? locationServiceProvider;
  HiveLocationProvider locationProvider = HiveLocationProvider();
  final geoService = GeoLocatorService();
  GoogleMapController? mapController;
  Position? position;
  Position? positionStream;
  LocationData? userLocation;
  late DriverLocationModel driverLocationModel;
  geocoding.Placemark? placeMarkStream;
  Marker? marker;
  Marker? startPointMarker;
  bool? isDriving;
  Circle? circle;
  StreamSubscription? locationSubscription;
  LatLng initialCameraPosition = const LatLng(23.256555, 90.157965);

  ///when start driving api call
  ///after that it's given us trackingId
  int? trackingId;
  String? currentDateData;
  bool? isLocationService;

  String? appSyncTimeServer = "0";
  String? liveDateStoreTime = "0";

  // LocationProvider() {
  //   getSettingBase();
  //   // currentDate();
  //   // getCurrentLocation();
  //   // addLocationDataToLocal(currentDateData);
  //   // deleteDataAndSendToServer(currentDateData);
  //
  //   // locationProvider.getDriverStartMoving(1); //todo user id need to change
  // }

  getSettingBase() async {
    var apiResponse = await Repository.baseSettingApi();
    if (apiResponse.result == true) {
      isLocationService = apiResponse.data?.data?.locationService;
      appSyncTimeServer = apiResponse.data?.data?.liveTracking?.appSyncTime;
      liveDateStoreTime =
          apiResponse.data?.data?.liveTracking?.liveDataStoreTime;
      apiResponse.data?.data?.liveTracking?.liveDataStoreTime;
      if (isLocationService == true) {
        currentDate();
        getCurrentLocation();
        addLocationDataToLocal(currentDateData);
        deleteDataAndSendToServer(currentDateData);
      }
      notifyListeners();
    }
  }

  currentDate() {
    DateTime now = DateTime.now();
    currentDateData = DateFormat('y-MM-d').format(now);
  }

  ///return future location
  getDriverPositionFuture() async {
    position = await geoService.getCordFuture();
    notifyListeners();
    // updateMarkerAndCircle();
  }

  ///return driver current location stream
  ///for this we use another package called {Location:any}
  ///to get location more better way
  void getCurrentLocation() {
    locationServiceProvider ??= LocationService();

    ///listening data from location service
    locationSubscription =
        locationServiceProvider?.locationStream.listen((event) async {
      ///initialize userLocation data
      userLocation = event;

      ///convert locationData into Position data
      positionStream = Position(
          latitude: event.latitude!,
          longitude: event.longitude!,
          speed: event.speed!,
          heading: event.heading!,
          altitude: event.altitude!,
          accuracy: event.accuracy!,
          timestamp: DateTime.now(),
          speedAccuracy: event.speedAccuracy!);

      ///getting address from current position
      getAddressByPosition();

      ///initial camera position
      initialCameraPosition = LatLng(event.latitude!, event.longitude!);

      ///update initial position and move camera position to
      ///center and it will call every time when we listen location
      ///from gps and driver is driving
      if (mapController != null) {
        mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(positionStream!.latitude, positionStream!.longitude),
            zoom: 16.0)));
      }

      ///updating marker and circle
      updateMarkerAndCircle();
    });
  }

  getAddressByPosition() async {
    final places = await geoService.getAddress(positionStream!);
    placeMarkStream = places?.elementAt(0);
    // placeMarkStream.refresh();
    notifyListeners();
  }

  // getAddressByPosition() async {
  //   final places = await geoService.getAddress(positionStream.value);
  //   placeMarkStream.value = places.elementAt(0);
  //   getDriverAddress();
  //   placeMarkStream.refresh();
  // }

  ///when user start driving
  ///tracking id must be null
  getDriverStartMoving(userId) async {
    ///requestData
    final data = {"is_stop": 0, "driver_id": userId, "tracking_id": null};

    ///serverRequest
    // final response = await repository.moveDriverLocationData(data);
    final response = await Repository.moveDriverLocationData(data);

    ///trackingId
    trackingId = response['tracking_id'];

    ///store recent trackingId to local
    SPUtill.storeLocalData(key: 'tracking_id', value: '$trackingId');

    ///toast
    Fluttertoast.showToast(msg: '${response['message']}');

    ///updateMarker
    updateMarkerAndCircle();

    ///storeLastKnownLocationToLocal
    SPUtill.storeLocalData(
        key: 'last_lat', value: '${positionStream?.latitude}');
    SPUtill.storeLocalData(
        key: 'last_lng', value: '${positionStream?.longitude}');

    ///if response success false
    ///firebase driving status will
    ///be 0 (stop state)
    // if(!response['success']){
    //   updateDataFirebase();
    // }
  }

  ///update marker and circle on map
  ///based on driver location
  updateMarkerAndCircle() async {
    final icon = await Common.setCustomMapPin('assets/car_icon/car_white.png');
    final originLat = await SPUtill.getLocalData(key: 'last_lat');
    final originLng = await SPUtill.getLocalData(key: 'last_lng');
    final origin = LatLng(
        double.parse(originLat ?? '0.0'), double.parse(originLng ?? '0.0'));

    marker = Marker(
        markerId: const MarkerId('current'),
        position: LatLng(userLocation!.latitude!, userLocation!.longitude!),
        icon: icon,
        flat: true,
        zIndex: 2,
        draggable: false,
        anchor: const Offset(0.5, 0.5),
        rotation: userLocation!.heading!,
        infoWindow: const InfoWindow(title: 'Current position'));

    startPointMarker = Marker(
        markerId: const MarkerId('origin'),
        position: origin,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        flat: true,
        visible: isDriving == true ? true : false,
        zIndex: 2,
        draggable: false,
        infoWindow: const InfoWindow(title: 'start position'));

    circle = Circle(
      circleId: const CircleId('car'),
      radius: userLocation!.accuracy!,
      zIndex: 1,
      strokeColor: CustomColors().mainColor(opacity: 0.1),
      center: LatLng(userLocation!.latitude!, userLocation!.longitude!),
      // fillColor: CustomColors().mainColor(1).withAlpha(70),
    );
  }

  onDrivingModeCameraPosition() {
    mapController?.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(userLocation!.latitude!, userLocation!.longitude!),
      zoom: 16.0,
      // bearing: 180.0
    )));
  }

  ///return last stored location from hive database
  getLastLocationFromLocal() {
    return locationProvider.getUserLastPosition();
  }

  ///return first stored location from hive database
  getFirstLocationFromLocal() {
    return locationProvider.getUserFirstPosition();
  }

  addLocationDataToLocal(String? currentDateData) async {
    Timer.periodic(Duration(minutes: int.parse(appSyncTimeServer.toString())), (timer) async {
      await getDriverPositionFuture();

      if (kDebugMode) {
        print('local from stream ${positionStream.toString()}');
        print('local from position ${position.toString()}');
      }

      double distance = 0.0;

      ///last position
      // DriverLocationModel? lastPosition = getLastLocationFromLocal();

      ///first position
      // DriverLocationModel? firstPosition = getFirstLocationFromLocal();

      ///check last position and first position
      ///if not null the try to get distance
      // if (lastPosition != null && firstPosition != null) {
      //   distance = await geoService.getDistance(
      //       LatLng(firstPosition.latitude, firstPosition.longitude),
      //       LatLng(lastPosition.latitude, lastPosition.longitude));
      // }

      driverLocationModel = DriverLocationModel(
          latitude: positionStream?.latitude ?? 0.0,
          longitude: positionStream?.longitude ?? 0.0,
          speed: positionStream?.speed ?? 0.0,
          city: placeMarkStream?.locality,
          country: placeMarkStream?.country,
          countryCode: placeMarkStream?.isoCountryCode,
          address:
              '${placeMarkStream?.name} ${placeMarkStream?.subLocality} ${placeMarkStream?.thoroughfare} ${placeMarkStream?.subThoroughfare}',
          heading: positionStream?.heading,
          distance: distance);

      ///add data to local database
      locationProvider.add(driverLocationModel);
    });
  }

  deleteDataAndSendToServer(String? currentDateData) async {
    ///periodicTimer
    Timer.periodic(Duration(minutes: int.parse(liveDateStoreTime.toString())), (timer) async {
      if (kDebugMode) {
        print(
            'data that u have to sent server ${locationProvider.toMapList()}');
      }

      // liveLocationData = await repository.sendStopLocationData(userId: uid, locations: locationProvider.toMapList(), trackingId: trackingId);

      final isSuccess = await Repository().sentStopLocationData(
          date: currentDateData, locations: locationProvider.toMapList());

      if (isSuccess) {
        await locationProvider.deleteAllLocation();
      }
      // ///updateWidgetTree
      // notifyListeners();
    });
  }
}
