import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/gallon.dart';
import 'package:refresco/core/models/store.dart';
import 'package:refresco/core/services/service_response.dart';

abstract class DatabaseService {
  /// Get all stores based on user address.
  ///
  /// If [address] is [Null], returns a [ServiceResponse] with success set to
  /// false and no message.
  ///
  /// If there are no stores near the user, return an empty [List], otherwise
  /// the list is populated with [Store] objects.
  Future<ServiceResponse> getStores(Address address);

  /// Get all gallons of a store.
  Future<ServiceResponse> getGallons(Store store, GallonType gallonType);
}
