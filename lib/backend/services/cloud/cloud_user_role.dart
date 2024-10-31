import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/foundation.dart';
import 'package:volunteerexpress/backend/services/cloud/firebase/constants/cloud_user_roles_constants.dart';

class CloudUserRole {
  final String docId;
  final String userId;
  final String userRole;

  @immutable
  CloudUserRole({
    required this.docId,
    required this.userId,
    required this.userRole,
  });

  // Firestore
  CloudUserRole.fromSnapshot(
      firestore.QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : docId = snapshot.id,
        userId = snapshot.data()[userRoleUidFieldName],
        userRole = snapshot.data()[userRoleFieldName];
}
