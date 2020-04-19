import 'package:refresco/core/models/order.dart';

class CreateOrder {
  static String get mutation => r'''
    mutation initOrder(      
      $streetName: String!
      $number: Float!
      $city: String!
      $state: String!
      $district: String!
      $country: String!
      $pointOfReference: String
      $complement: String
      $postalCode: String!

      $latitude: Float!
      $longitude: Float!
      
      $orderItems: [CreateOrderItemFieldsInput!]!
      $store: ID!
      $paymentMethod: ID!
      $change: Int!
    ) {
      initOrder(
        store: $store
        address: {
          streetName: $streetName
          number: $number
          city: $city
          state: $state
          district: $district
          country: $country
          pointOfReference: $pointOfReference
          complement: $complement
          coordinate: { latitude: $latitude, longitude: $longitude }
          postalCode: $postalCode
        }
        paymentMethod: $paymentMethod
        orderItems: $orderItems
        change: $change
      ) {
        objectId
      }
    }
  ''';

  static Map<String, dynamic> builder(Order order) {
    final orderItems = order.orderItems.map((p) {
      final orderItem = {
        'amount': p.amount,
        'product': {'link': p.product.id},
      };
      return orderItem;
    }).toList();

    return {
      'streetName': order.address.streetName,
      'number': order.address.number,
      'city': order.address.city,
      'state': order.address.state,
      'district': order.address.district,
      'country': order.address.country,
      'pointOfReference': order.address.pointOfReference,
      'complement': order.address.complement,
      'postalCode': order.address.postalCode,
      'latitude': order.address.coordinate.latitude,
      'longitude': order.address.coordinate.longitude,

      'orderItems': orderItems,
      'store': order.store.id,
      'paymentMethod': 'UOZrC98GJE', // TODO: add payment methods in database
      'change': order.paymentMethod.change
    };
  }
}
