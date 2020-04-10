import 'package:flutter/foundation.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';

class CreateOrder {
  static String get mutation => r'''
    mutation createOrder(
      $storeId: ID!
      $userId: ID!
      
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
      
      $orderStatus: String!
      
      $paymentMethodId: ID!
      
      $products: [CreateOrderItemFieldsInput!]
    ) {
      createOrder(
        input: {
          fields: {
            store: { link: $storeId }
            buyer: { link: $userId }
            address: {
              createAndLink: {
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
            }
            orderStatus: $orderStatus
            paymentMethod: { link: $paymentMethodId }
            products: {
              createAndAdd: $products
            }
          }
        }
      ) {
        order {
          objectId
        }
      }
    }
  ''';

  static Map<String, dynamic> builder(Order order) {
    final products = order.products.map((p) {
      final objMap = p.toJson();
      objMap['product'] = {'link': objMap['product']['objectId']};

      return objMap;
    }).toList();

    return {
      'products': products,
      'storeId': order.store.id,
      'userId': order.buyer.id,
      'orderStatus': describeEnum(OrderStatus.pending),
      'paymentMethodId': 'UOZrC98GJE', // TODO: add payment methods in database
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
    };
  }
}
