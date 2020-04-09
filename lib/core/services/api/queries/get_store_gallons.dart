class GetStoreGallons {
  static String get query => r'''
    query getStoreGallons(
      $gallonType: String!
      $storeId: ID!
    ) {
      gallons(where: {
        type: {equalTo: $gallonType}
        store: {
          have: {
            objectId: {equalTo: $storeId}
          }
        }
      }) {
        edges {
          node {
            price
            type
            objectId
            company
            store {
              objectId
            }
          }
        }
      }
    }
  ''';
}
