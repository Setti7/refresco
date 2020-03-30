import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/services/location/location_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';
import 'package:rxdart/rxdart.dart';

class LocationSearchModel extends BaseModel {
  final LocationService _locationService = locator<LocationService>();

  final BehaviorSubject<List<Address>> _addressesSubject =
      BehaviorSubject<List<Address>>();

  Observable<List<Address>> get addressesObservable =>
      _addressesSubject.stream;

  void updateQuery(String query) async {
    if (query == '' || query == null) {
      _addressesSubject.add(null);
      return;
    }

    var addresses =
        await _locationService.findAddressesFromQuery(query);
    _addressesSubject.add(addresses);
  }

  @override
  void dispose() {
    _addressesSubject.close();
    super.dispose();
  }
}
