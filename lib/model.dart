class LaunchDataModel {
  final String idMission;
  final String name;
  final String launchDate;
  final List<String> img;
  final String logo;
  final String success;
  final List<dynamic> crew;
  final String details;
  final String landingAttempt;
  final String landingSuccess;

  LaunchDataModel({
    required this.idMission,
    required this.name,
    required this.launchDate,
    required this.img,
    required this.logo,
    required this.success,
    required this.crew,
    required this.details,
    required this.landingAttempt,
    required this.landingSuccess,
  });
}
