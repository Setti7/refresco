class GetCloseStoresQuery {
  static String get query => r'''
    query getCloseStores(
      $latitude: Float!
      $longitude: Float!
    ) {
      stores(
        where: {
          address: {
            have: {
              coordinate: {
                nearSphere: { latitude: $latitude, longitude: $longitude }
                maxDistanceInKilometers: 10.0
              }
            }
          }
        }
      ) {
        edges {
          node {
            objectId
            name
            rating
            minDeliveryTime
            maxDeliveryTime
            address {
              coordinate {
                latitude
                longitude
              }
            }
          }
        }
      }
    }
  ''';
}
