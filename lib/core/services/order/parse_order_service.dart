import 'package:graphql/client.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/api/mutations/create_order.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/order/order_service.dart';
import 'package:refresco/locator.dart';

/// User is authorized by the session token, so it must be set beforehand, by
/// the [AuthService].
class ParseOrderService implements OrderService {
  GraphQLApi api = locator<GraphQLApi>();

  // Always returns null results.
  Future<ServiceResponse> createOrder(Order order) async {
    final response = await api.mutate(
      MutationOptions(
        documentNode: gql(CreateOrder.mutation),
        variables: CreateOrder.builder(order),
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu.',
      );
    }
    return ServiceResponse(success: true);
  }

  Future<ServiceResponse> getPastOrders() async {
    return null;
  }

  Stream<ServiceResponse> subscribeToOngoingOrders() {
    return null;
  }
}
