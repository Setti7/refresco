import 'package:flutter/cupertino.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/locator.dart';
import 'package:refresco/core/viewModels/base_model.dart';

class CurrentLocationTileModel extends BaseModel {
  LocationService locationService = locator<LocationService>();
  Address currentAddress;

  void Function(BuildContext, Address) closeCallback;
  BuildContext searchContext;

  void getCurrentAddress() async {
    if (locationService.currentAddress != null) {
      currentAddress = locationService.currentAddress;
      setState(ViewState.idle);
    } else {
      setState(ViewState.busy);
      var address = await locationService.getCurrentAddress();
      currentAddress = address;
      setState(ViewState.idle);
    }
  }

  void selectAddress() {
    closeCallback(searchContext, currentAddress);
  }
}
