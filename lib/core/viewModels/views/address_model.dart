import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/services/location/location_service.dart';
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

  void setAddress(Address value) {
    if (value != null) {
      showAddress = value;
      numberController.text = value.number?.toString();
      complementController.text = value.complement;
      pointOfReferenceController.text = value.pointOfReference;
    }
  }

  void updateSelectedAddress(Address value) {
    if (value == null) {
      return;
    }

    showAddress = value;
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
      final pointOfReference = pointOfReferenceController.text;
      final complement = complementController.text;
      final number = int.tryParse(numberController.text);

      final updatedAddress = showAddress.clone(
        number: number,
        complement: complement == '' ? null : complement,
        pointOfReference: pointOfReference == '' ? null : pointOfReference,
      );

      locationService.updateAddress(updatedAddress);
      Get.back();
    }

    setState(ViewState.idle);
  }
}
