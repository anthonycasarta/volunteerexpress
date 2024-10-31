import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_exceptions/cloud_user_role_exception.dart';
import 'package:volunteerexpress/backend/services/cloud/cloud_user_role.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_user_roles_constants.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/firebase_cloud_storage.dart';

class FirebaseUserRolesService {
  final FirebaseFirestore firestore;

  FirebaseUserRolesService({required this.firestore});

  // Use the singleton instance of FirebaseCloudStorage
  static final FirebaseCloudStorage _firebaseCloudStorage =
      FirebaseCloudStorage();

  late final userRoles = firestore.collection('user_roles');

  Future<CloudUserRole> getRole({required userId}) async {
    try {
      // return await userRoles
      //     .where(
      //       userRoleUidFieldName,
      //       isEqualTo: userId,
      //     )
      //     .get();
    } catch (e) {
      throw CouldNotGetUserRoleException();
    }
  }

  void addRole({required String userId, required String userRole}) async {
    await userRoles.add({
      userRoleFieldName: userRole,
      userRoleUidFieldName: userId,
    });
  }
}
