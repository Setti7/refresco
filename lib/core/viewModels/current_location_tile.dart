import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/user_address.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/locator.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';

class CurrentLocationTileModel extends BaseModel {
  LocationService locationService = locator<LocationService>();
  UserAddress currentAddress;

  void Function(BuildContext, UserAddress) closeCallback;
  BuildContext searchContext;

  void getCurrentAddress() async {
    if (locationService.currentAddress != null) {
      currentAddress = locationService.currentAddress;
      setState(ViewState.idle);
    } else {
      setState(ViewState.busy);
      UserAddress address = await locationService.getCurrentAddress();
      currentAddress = address;
      setState(ViewState.idle);
    }
  }

  void selectAddress() {
    closeCallback(searchContext, currentAddress);
  }
}
