class FirebaseCloudStorage {
  // Create a singleton
  static final FirebaseCloudStorage _sharedInst =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _sharedInst;
}
