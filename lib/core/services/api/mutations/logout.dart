class Logout {
  static String get mutation => r'''
    mutation logOut {
      logOut(input: { clientMutationId: "logOut" }) {
        clientMutationId
      }
    }
  ''';
}
