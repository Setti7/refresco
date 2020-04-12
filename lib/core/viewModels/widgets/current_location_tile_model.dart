import 'package:flutter/cupertino.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';

class CurrentLocationTileModel extends BaseModel {
  LocationService locationService = locator<LocationService>();
  Address currentAddress;

  void Function(BuildContext, Address) closeCallback;
  BuildContext searchContext;

  void getCurrentAddress() async {
    // TODO: add error handling here and inside the service method
    setState(ViewState.busy);
    final response = await locationService.getUserAddressFromGPS();

    if (response.success) {
      currentAddress = response.results.first;
    }

    setState(ViewState.idle);
  }

  void selectAddress() {
    closeCallback(searchContext, currentAddress);
  }
}
