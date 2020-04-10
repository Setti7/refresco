import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/services/auth/auth_service.dart';

/// User is authorized by the session token, so it must be set beforehand, by
/// the [AuthService].
abstract class OrderService {

  /// Initialize a new [Order] for the current [User].
  Future<ServiceResponse> initOrder(Order order);

  /// Get all past [Order]s for the current [User].
  ///
  /// If the user has no past orders, return [ServiceResponse] with empty
  /// results.
  Future<ServiceResponse> getPastOrders();

  /// Subscribe to all ongoing [Order]s (with [OrderStatus.pending] status).
  Stream<ServiceResponse> subscribeToOngoingOrders();
}
