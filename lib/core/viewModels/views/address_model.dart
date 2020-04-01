import 'package:flutter/cupertino.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/services/location/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';

/// TODO:
/// Make number field required
/// When changing only the number and not the saved address it crashes
class AddressModel extends BaseModel {
  LocationService locationService = locator<LocationService>();

  Address _userAddress;
  String errorMessage;

  set userAddress(Address userAddress) {
    _userAddress = userAddress;

    if (userAddress != null) {
      numberController.text = _userAddress.number?.toString();
      complementController.text = _userAddress.complement;
      pointOfReferenceController.text = _userAddress.pointOfReference;
    }
  }

  Address showAddress;

  // Controllers
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController pointOfReferenceController = TextEditingController();

  void evaluateWhichAddressToShow() {
    if (_userAddress != null) {
      showAddress = _userAddress;
    }
  }

  void updateSelectedAddress(Address address) {
    showAddress = address;
    numberController.clear();
    complementController.clear();
    pointOfReferenceController.clear();
    setState(ViewState.idle);
  }

  bool saveNewAddress() {
    if (showAddress == null) {
      errorMessage = 'Selecione um endereço';
    } else if (numberController.text == '') {
      errorMessage = 'Por favor, insira o número';
    } else {
      errorMessage = null;
      locationService.updateUserAddress(
        showAddress,
        number: int.tryParse(numberController.text),
        complement:
            complementController.text == '' ? null : complementController.text,
        pointOfReference: pointOfReferenceController.text == ''
            ? null
            : pointOfReferenceController.text,
      );
      return true;
    }

    setState(ViewState.idle);
    return false;
  }
}
