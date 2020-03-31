import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';
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
