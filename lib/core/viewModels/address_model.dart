import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/address.dart';
import 'package:flutter_base/core/services/location/location_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';

/// TODO:
/// Make number field required
/// When changing only the number and not the saved address it crashes
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

  //TODO: handle error better
  void saveNewAddress(Address userAddress) {
    if (userAddress == null && selectedAddress == null) {
      throw NullThrownError();
    }

    locationService.updateUserAddress(
      selectedAddress ?? userAddress,
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
