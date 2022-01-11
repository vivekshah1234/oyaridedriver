class PlaceDetails {
  PlaceDetails({
    required this.htmlAttributions,
    required this.result,
    required this.status,
  });
  late final List<dynamic> htmlAttributions;
  late final Result result;
  late final String status;

  PlaceDetails.fromJson(Map<String, dynamic> json){
    htmlAttributions = List.castFrom<dynamic, dynamic>(json['html_attributions']);
    result = Result.fromJson(json['result']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['html_attributions'] = htmlAttributions;
    _data['result'] = result.toJson();
    _data['status'] = status;
    return _data;
  }
}

class Result {
  Result({
    required this.addressComponents,
    required this.adrAddress,
    required this.formattedAddress,
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.placeId,
    required this.reference,
    required this.types,
    required this.url,
    required this.utcOffset,
    required this.vicinity,
  });
  late final List<AddressComponents> addressComponents;
  late final String adrAddress;
  late final String formattedAddress;
  late final Geometry geometry;
  late final String icon;
  late final String iconBackgroundColor;
  late final String iconMaskBaseUri;
  late final String name;
  late final String placeId;
  late final String reference;
  late final List<String> types;
  late final String url;
  late final int utcOffset;
  late final String vicinity;

  Result.fromJson(Map<String, dynamic> json){
    addressComponents = List.from(json['address_components']).map((e)=>AddressComponents.fromJson(e)).toList();
    adrAddress = json['adr_address'];
    formattedAddress = json['formatted_address'];
    geometry = Geometry.fromJson(json['geometry']);
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    placeId = json['place_id'];
    reference = json['reference'];
    types = List.castFrom<dynamic, String>(json['types']);
    url = json['url'];
    utcOffset = json['utc_offset'];
    vicinity = json['vicinity'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['address_components'] = addressComponents.map((e)=>e.toJson()).toList();
    _data['adr_address'] = adrAddress;
    _data['formatted_address'] = formattedAddress;
    _data['geometry'] = geometry.toJson();
    _data['icon'] = icon;
    _data['icon_background_color'] = iconBackgroundColor;
    _data['icon_mask_base_uri'] = iconMaskBaseUri;
    _data['name'] = name;
    _data['place_id'] = placeId;
    _data['reference'] = reference;
    _data['types'] = types;
    _data['url'] = url;
    _data['utc_offset'] = utcOffset;
    _data['vicinity'] = vicinity;
    return _data;
  }
}

class AddressComponents {
  AddressComponents({
    required this.longName,
    required this.shortName,
    required this.types,
  });
  late final String longName;
  late final String shortName;
  late final List<String> types;

  AddressComponents.fromJson(Map<String, dynamic> json){
    longName = json['long_name'];
    shortName = json['short_name'];
    types = List.castFrom<dynamic, String>(json['types']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['long_name'] = longName;
    _data['short_name'] = shortName;
    _data['types'] = types;
    return _data;
  }
}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });
  late final Location location;
  late final Viewport viewport;

  Geometry.fromJson(Map<String, dynamic> json){
    location = Location.fromJson(json['location']);
    viewport = Viewport.fromJson(json['viewport']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['location'] = location.toJson();
    _data['viewport'] = viewport.toJson();
    return _data;
  }
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Location.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });
  late final Northeast northeast;
  late final Southwest southwest;

  Viewport.fromJson(Map<String, dynamic> json){
    northeast = Northeast.fromJson(json['northeast']);
    southwest = Southwest.fromJson(json['southwest']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['northeast'] = northeast.toJson();
    _data['southwest'] = southwest.toJson();
    return _data;
  }
}

class Northeast {
  Northeast({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Northeast.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}

class Southwest {
  Southwest({
    required this.lat,
    required this.lng,
  });
  late final double lat;
  late final double lng;

  Southwest.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}