import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/address.dart';
import 'package:refresco/core/models/coordinate.dart';

abstract class BaseLocationService {
  /// Startup function to load the [Address] saved to disk.
  ///
  /// Should only be run at startup time.
  Future<void> loadAddress();

  /// [Address] stream.
  Stream<Address> get address;

  /// Updates the [Address] stream and saves the value locally.
  void updateAddress(Address value);

  /// Returns the most recent [Address] from [address] stream.
  Address getAddress();

  /// Uses the device's location service to get the user's location.
  ///
  /// [ServiceResponse.results] will be null with any error is thrown.
  /// Otherwise, the first element of the results list will be the user's
  /// current [Address].
  Future<ServiceResponse> getUserAddressFromGPS();


  /// Uses the device's location service to query a location.
  ///
  /// If an error is thrown, [ServiceResponse.results] will be null.
  /// Otherwise, the results will be the [Address]es returned by the query.
  Future<ServiceResponse> findAddressesFromQuery(String query);

  /// Helper function to calculate distance between two [Coordinate]s.
  double getDistanceBetweenCoordinates(Coordinate c1, Coordinate c2);
}
