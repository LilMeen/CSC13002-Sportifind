class PlayerInformation {
  const PlayerInformation({
    required this.name,
    required this.address,
    required this.district,
    required this.city,
    required this.dob,
    required this.email,
    required this.avatarImageUrl,
    required this.gender,
    required this.phoneNumber,
    required this.teams,
  });

  final String name;
  final String address;
  final String district;
  final String city;
  final String dob;
  final String email;
  final String avatarImageUrl;
  final String gender;
  final String phoneNumber; 
  final List<String> teams; 
}
