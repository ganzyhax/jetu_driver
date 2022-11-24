import 'dart:convert';

import 'package:latlong2/latlong.dart';

PlaceItem placeFromJson(String str) => PlaceItem.fromJson(json.decode(str));

class PlaceItem {
  PlaceItem({
    this.features,
    this.type,
  });

  List<Feature>? features;
  String? type;

  factory PlaceItem.fromJson(Map<String, dynamic> json) => PlaceItem(
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        type: json["type"],
      );
}

class Feature {
  Feature({
    this.latLng,
    this.properties,
  });

  LatLng? latLng;
  Properties? properties;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        latLng: LatLng(
          json["geometry"]['coordinates'][1],
          json["geometry"]['coordinates'][0],
        ),
        properties: Properties.fromJson(json["properties"]),
      );
}

class Properties {
  Properties({
    this.osmType,
    this.osmId,
    this.extent,
    this.country,
    this.osmKey,
    this.countrycode,
    this.osmValue,
    this.name,
    this.type,
    this.city,
    this.street,
    this.district,
    this.postcode,
    this.county,
    this.state,
    this.housenumber,
  });

  String? osmType;
  int? osmId;
  List<double>? extent;
  String? country;
  String? osmKey;
  String? countrycode;
  String? osmValue;
  String? name;
  String? type;
  String? city;
  String? street;
  String? district;
  String? postcode;
  String? county;
  String? state;
  String? housenumber;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        extent: json["extent"] == null
            ? null
            : List<double>.from(json["extent"].map((x) => x.toDouble())),
        country: json["country"],
        osmKey: json["osm_key"],
        countrycode: json["countrycode"],
        osmValue: json["osm_value"],
        name: json["name"],
        type: json["type"],
        city: json["city"] == null ? null : json["city"],
        street: json["street"] == null ? null : json["street"],
        district: json["district"] == null ? null : json["district"],
        postcode: json["postcode"] == null ? null : json["postcode"],
        county: json["county"] == null ? null : json["county"],
        state: json["state"] == null ? null : json["state"],
        housenumber: json["housenumber"] == null ? null : json["housenumber"],
      );
}
