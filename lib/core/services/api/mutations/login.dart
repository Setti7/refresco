class Login {
  static String get mutation => r'''
    mutation login(
      $email: String!
      $password: String!
    ) {
      logIn(input: { username: $email, password: $password }) {
        viewer {
          sessionToken
          user {
            objectId
            email
          }
        }
      }
    }
  ''';
}
