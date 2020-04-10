import 'package:flutter/foundation.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';

/// TODO:
/// test with simpler class, remove all field and leave only [products], and
/// try with it.
///
/// Whats happens when i pass the object like this?
///           variables: {'address': order.address.toJson()},
///  How can i access address variables inside it? address.streetName?
class InitOrder {
  static String get mutation => r'''
    mutation createOrder(
      $storeId: ID!
      $userId: ID!
      
      $address: CreateAddressFieldsInput!
      
      $orderStatus: String!
      $paymentMethodId: ID!
      $products: [CreateOrderItemFieldsInput!]
    ) {
      createOrder(
        input: {
          fields: {
            store: { link: $storeId }
            buyer: { link: $userId }
            address: { createAndLink: $address }
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
      var objMap = p.toJson();

      objMap.removeWhere((key, value) => objMap[key] == null);
      objMap['product'] = {'link': objMap['product']['objectId']};

      return objMap;
    }).toList();

    final storeId = order.store.id;
    final userId = order.buyer.id;
    final orderStatus = describeEnum(OrderStatus.pending);
    final paymentMethodId = 'UOZrC98GJE';

    var address = order.address.toJson();
    address.remove(['objectId']);
    address['coordinates'] = address['coordinates'].toJson();

    return {
      'products': products,
      'storeId': storeId,
      'userId': userId,
      'orderStatus': orderStatus,
      'paymentMethodId': paymentMethodId,
      'address': address,
    };
  }

  static String get test => r'''
    mutation createTest(
      $products: [CreateOrderItemFieldsInput!]
    ) {
      createTest(
        input: {
          fields: {
            products: {
              createAndAdd: $products
            }
          }
        }
      ) {
        clientMutationId
      }
    } 
  ''';
}

//    mutation registerNewTeacher(
//    \$email: String!
//    \$fullname: String!
//    \$cellphone: String!
//    \$birthday: Date!
//    \$street: String!
//    \$number: String!
//    \$complement: String!
//    \$zipCode: String!
//    \$city: String!
//    \$province: String!
//) {
//  registerNewTeacher(
//    email: \$email
//    fullname: \$fullname
//    cellphone: \$cellphone
//    birthday: \$birthday
//    address: {
//      street: \$street
//      number: \$number
//      complement: \$complement
//      zipCode: \$zipCode
//      city: \$city
//      province: \$province
//    }
//  ) {
//    commonResponse {
//      isError
//      statusCode
//      description
//    }
//    genericUser {
//      teacher {
//        id
//        fullName
//      }
//    }
//  }
//}
