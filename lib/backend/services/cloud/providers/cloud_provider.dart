abstract class CloudProvider {
  Future<void> updateVolunteerStatus({
    required volunteerUid,
    required docId,
    required volunteerStatus,
  });
}
