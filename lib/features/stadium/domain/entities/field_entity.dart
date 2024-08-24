class FieldEntity {
  final String id;
  final int numberId;
  final String type;
  final double price;
  final bool status;

  FieldEntity({
    required this.id,
    required this.numberId,
    required this.type,
    required this.price,
    required this.status,
  });

  FieldEntity copyWith({
    String? id,
    int? numberId,
    String? type,
    double? price,
    bool? status,
  }) {
    return FieldEntity(
      id: id ?? this.id,
      numberId: numberId ?? this.numberId,
      type: type ?? this.type,
      price: price ?? this.price,
      status: status ?? this.status,
    );
  }
}
