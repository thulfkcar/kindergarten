import 'package:flutter/cupertino.dart';
import 'package:kid_garden_app/presentation/utile/LangUtiles.dart';

String locationConvertorTracker(double distance, BuildContext context) {
  var result =
      AppLocalizations.of(context)?.getText("about_distance") ?? "about ";
  double distanceInMeters = distance;
  double distanceInKiloMeters = distanceInMeters / 1000;
  double roundDistanceInKM =
      double.parse((distanceInKiloMeters).toStringAsFixed(2));
  double roundDistanceInMeters =
      double.parse((distanceInMeters).toStringAsFixed(2));
  if (roundDistanceInKM < 1) {

    result = result +" "+ roundDistanceInMeters.toString();
    result =result +" "+ (AppLocalizations.of(context)?.getText("meters") ?? " meters");
    return result;
  } else {
    result = result +" "+ roundDistanceInKM.toString();
    result =result +" "+ (AppLocalizations.of(context)?.getText("km") ?? " km");
    return result;
  }
}
