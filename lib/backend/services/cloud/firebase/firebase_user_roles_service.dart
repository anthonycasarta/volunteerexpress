import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_exceptions/cloud_user_role_exception.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_user_role.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_user_roles_constants.dart';

class FirebaseUserRolesService {
  final FirebaseFirestore firestore;

  // Private constructor
  FirebaseUserRolesService._sharedInstance(this.firestore);

  // Singleton instance
  static FirebaseUserRolesService? _shared;

  // Factory constructor
  factory FirebaseUserRolesService({FirebaseFirestore? firestore}) {
    // If _instance is null, create a new instance
    _shared ??= FirebaseUserRolesService._sharedInstance(
      firestore ?? FirebaseFirestore.instance,
    );
    return _shared!;
  }

  late final userRoles = firestore.collection('user_roles');

  Future<String> getRole({required userId}) async {
    try {
      return await userRoles
          .where(
            userRoleUidFieldName,
            isEqualTo: userId,
          )
          .get()
          .then(
              (value) => value.docs.first.data()[userRoleFieldName] as String);
    } catch (e) {
      throw CouldNotGetUserRoleException();
    }
  }

  void addRole({required String userId, required String userRole}) async {
    try {
      await userRoles.add({
        userRoleFieldName: userRole,
        userRoleUidFieldName: userId,
      });
    } catch (e) {
      throw CouldNotAddUserRoleException();
    }
  }
}
