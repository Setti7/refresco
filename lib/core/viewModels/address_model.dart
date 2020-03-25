import 'package:flutter/cupertino.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/models/user_address.dart';
import 'package:flutter_base/core/services/location_service.dart';
import 'package:flutter_base/core/viewModels/base_model.dart';
import 'package:flutter_base/locator.dart';

class AddressModel extends BaseModel {
  LocationService locationService = locator<LocationService>();

  UserAddress selectedAddress;
  UserAddress userAddress;
  int streetNumber;

  // Controllers
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController pointOfReferenceController = TextEditingController();

  void updateSelectedAddress(UserAddress address) {
    selectedAddress = address;
    setState(ViewState.idle);
  }

  void saveNewAddress() {
    // TODO: save address to user
    userAddress = UserAddress.copy(
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
