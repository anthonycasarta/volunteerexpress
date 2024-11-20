
class Profile {
  String fullName;
  String address;
  String city;
  String state;
  String zipCode;
  List<String> selectedSkills;
  List<String> dates;
  String userID;

  Profile({
    required this.fullName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.selectedSkills,
    required this.dates,
    required this.userID,
  }); 
}
