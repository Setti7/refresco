import 'package:graphql/client.dart';
import 'package:refresco/core/dataModels/service_response.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/services/api/graphql_api.dart';
import 'package:refresco/core/services/api/mutations/init_order.dart';
import 'package:refresco/core/services/auth/auth_service.dart';
import 'package:refresco/core/services/order/order_service.dart';
import 'package:refresco/locator.dart';

/// User is authorized by the session token, so it must be set beforehand, by
/// the [AuthService].
class ParseOrderService implements OrderService {
  GraphQLApi api = locator<GraphQLApi>();

  Future<ServiceResponse> initOrder(Order order) async {
    final response = await api.mutate(
      MutationOptions(
        documentNode: gql(InitOrder.mutation),
        variables: {
          'storeId': order.store.id,
          'userId': order.buyer.id,
          'address': order.address.toJson(),
          'orderStatus': 'pending',
          'paymentMethodId': order.paymentMethod.id,
          'paymentMethodId': order.paymentMethod.id,
          'products': order.products.map((p) => p.toJson()).toList(),
        },
      ),
    );

    if (response.hasException) {
      return ServiceResponse(
        success: false,
        errorTitle: 'Opa :(',
        errorMessage: 'Um erro inesperado ocorreu com o servidor.',
      );
    }
  }

  Future<ServiceResponse> getPastOrders() async {}

  Stream<ServiceResponse> subscribeToOngoingOrders() {}
}
