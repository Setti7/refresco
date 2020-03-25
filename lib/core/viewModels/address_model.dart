import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/services/service_locator.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';

// TODO: convert to fixed states
class AddressModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();

  BehaviorSubject<List<Address>> _addressesSubject =
      BehaviorSubject<List<Address>>();

  Observable<List<Address>> get addressesObservable => _addressesSubject.stream;

  void updateQuery(String query) async {
    if (query == '' || query == null) {
      _addressesSubject.add(null);
      return;
    }

    List<Address> addresses =
        await _locationService.findAddressesFromQuery(query);
    _addressesSubject.add(addresses);
  }

  @override
  void dispose() {
    _addressesSubject.close();
    super.dispose();
  }
}
