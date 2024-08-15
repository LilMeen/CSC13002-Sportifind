class BookingEntity {
  ///
  /// The userId of the currently logged user
  /// who will start the new booking
  final String? userId;

  /// The userName of the currently logged user
  /// who will start the new booking
  final String? userName;

  /// The userEmail of the currently logged user
  /// who will start the new booking
  final String? userEmail;

  /// The userPhoneNumber of the currently logged user
  /// who will start the new booking
  final String? userPhoneNumber;

  /// The id of the currently selected Service
  /// for this service will the user start the new booking

  final String? serviceId;

  ///The name of the currently selected Service
  final String serviceName;

  ///The duration of the currently selected Service

  final int serviceDuration;

  ///The price of the currently selected Service

  final int? servicePrice;

  ///The selected booking slot's starting time
  DateTime bookingStart;

  ///The selected booking slot's ending time
  DateTime bookingEnd;

  BookingEntity({
    this.userEmail,
    this.userPhoneNumber,
    this.userId,
    this.userName,
    required this.bookingStart,
    required this.bookingEnd,
    this.serviceId,
    required this.serviceName,
    required this.serviceDuration,
    this.servicePrice,
  });
}
