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
