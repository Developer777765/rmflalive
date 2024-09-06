import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mobile_number/sim_card.dart';

class MobileNumberAccess {
  final String mobileNumber;
  final List<SimCard> simCard;

  MobileNumberAccess({
    required this.mobileNumber,
    required this.simCard,
  });

  MobileNumberAccess copyWith({
    String? mobileNumber,
    List<SimCard>? simCard,
  }) {
    return MobileNumberAccess(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      simCard: simCard ?? this.simCard,
    ); 
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mobileNumber': mobileNumber,
      'simCard': simCard.map((x) => x.toMap()).toList(),
    };
  }

  factory MobileNumberAccess.fromMap(Map<String, dynamic> map) {
    return MobileNumberAccess(
      mobileNumber: map['mobileNumber'] as String,
      simCard: List<SimCard>.from(
        (map['simCard'] as List<int>).map<SimCard>(
          (x) => SimCard.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MobileNumberAccess.fromJson(String source) =>
      MobileNumberAccess.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MobileNumberAccess(mobileNumber: $mobileNumber, simCard: $simCard)';

  @override
  bool operator ==(covariant MobileNumberAccess other) {
    if (identical(this, other)) return true;

    return other.mobileNumber == mobileNumber &&
        listEquals(other.simCard, simCard);
  }

  @override
  int get hashCode => mobileNumber.hashCode ^ simCard.hashCode;
}
