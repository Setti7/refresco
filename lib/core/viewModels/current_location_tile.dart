import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/services/service_locator.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:geocoder/geocoder.dart';

class CurrentLocationTileModel extends BaseModel {
  LocationService locationService = locator<LocationService>();
  Address _currentAddress;

  void getCurrentAddress() async {
    if (locationService.currentAddress != null) {
      _currentAddress = locationService.currentAddress;
      setState(ViewState.idle);
    } else {
      setState(ViewState.busy);
      Address address = await locationService.getCurrentAddress();
      _currentAddress = address;
      setState(ViewState.idle);
    }
  }

  String get address {
    if (_currentAddress == null) return null;

    String street = _currentAddress.thoroughfare;
    String city = _currentAddress.subAdminArea;

    return "$street - $city";
  }
}
