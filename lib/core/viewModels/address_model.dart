import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';

/// TODO:
/// Make number field required
class AddressModel extends BaseModel {
  LocationService locationService = locator<LocationService>();

  Address selectedAddress;

  // Controllers
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController pointOfReferenceController = TextEditingController();

  void updateSelectedAddress(Address address) {
    selectedAddress = address;
    setState(ViewState.idle);
  }

  void saveNewAddress() {
    locationService.updateUserAddress(
      selectedAddress,
      number: numberController.text == ''
          ? null
          : int.tryParse(numberController.text),
      complement:
          complementController.text == '' ? null : complementController.text,
      pointOfReference: pointOfReferenceController.text == ''
          ? null
          : pointOfReferenceController.text,
    );
  }
}
