import 'package:flutter_base/core/models/user_address.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';
import 'package:rxdart/rxdart.dart';

class LocationSearchModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();

  BehaviorSubject<List<UserAddress>> _addressesSubject =
      BehaviorSubject<List<UserAddress>>();

  Observable<List<UserAddress>> get addressesObservable =>
      _addressesSubject.stream;

  void updateQuery(String query) async {
    if (query == '' || query == null) {
      _addressesSubject.add(null);
      return;
    }

    List<UserAddress> addresses =
        await _locationService.findAddressesFromQuery(query);
    _addressesSubject.add(addresses);
  }

  @override
  void dispose() {
    _addressesSubject.close();
    super.dispose();
  }
}
