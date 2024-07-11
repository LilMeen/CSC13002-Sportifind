class TeamInformation {
  TeamInformation({
    required this.name,
    required this.address, 
    required this.district, 
    required this.city, 
    required this.avatarImageUrl, 
    required this.members, 
    required this.captain,
  });

  String name;
  String address;
  String district;
  String city;
  String avatarImageUrl;
  String captain;
  List<String> members;
}
