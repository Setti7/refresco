import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/services/location_service.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';

class AddressModel extends BaseModel {
  LocationService locationService = locator<LocationService>();

  String errorMessage;
  Address showAddress;

  // Controllers
  TextEditingController numberController = TextEditingController();
  TextEditingController complementController = TextEditingController();
  TextEditingController pointOfReferenceController = TextEditingController();

  set userAddress(Address userAddress) {
    if (userAddress != null) {
      showAddress = userAddress;
      numberController.text = userAddress.number?.toString();
      complementController.text = userAddress.complement;
      pointOfReferenceController.text = userAddress.pointOfReference;
    }
  }

  void updateSelectedAddress(Address address) {
    if (address == null) {
      return;
    }

    showAddress = address;
    numberController.clear();
    complementController.clear();
    pointOfReferenceController.clear();
    setState(ViewState.idle);
  }

  void saveNewAddress() {
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
      Get.back();
    }

    setState(ViewState.idle);
  }
}
