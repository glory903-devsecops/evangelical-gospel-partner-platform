import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evangelical_gospel_partner/features/churches/domain/entities/church.dart';

class ChurchModel extends Church {
  ChurchModel({
    required super.id,
    required super.tenantId,
    required super.name,
    required super.denomination,
    required super.pastorName,
    required super.memberCount,
    required super.youthCount,
    required super.distance,
    required super.address,
    super.latitude,
    super.longitude,
    required super.yearlyWord,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChurchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChurchModel(
      id: doc.id,
      tenantId: data['tenantId'] ?? '',
      name: data['name'] ?? '',
      denomination: data['denomination'] ?? '',
      pastorName: data['pastorName'] ?? '',
      memberCount: data['memberCount'] ?? 0,
      youthCount: data['youthCount'] ?? 0,
      distance: data['distance'] ?? 0,
      address: data['address'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      yearlyWord: data['yearlyWord'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tenantId': tenantId,
      'name': name,
      'denomination': denomination,
      'pastorName': pastorName,
      'memberCount': memberCount,
      'youthCount': youthCount,
      'distance': distance,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'yearlyWord': yearlyWord,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ChurchModel copyWith({
    String? id,
    String? tenantId,
    String? name,
    String? denomination,
    String? pastorName,
    int? memberCount,
    int? youthCount,
    int? distance,
    String? address,
    double? latitude,
    double? longitude,
    String? yearlyWord,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChurchModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      name: name ?? this.name,
      denomination: denomination ?? this.denomination,
      pastorName: pastorName ?? this.pastorName,
      memberCount: memberCount ?? this.memberCount,
      youthCount: youthCount ?? this.youthCount,
      distance: distance ?? this.distance,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      yearlyWord: yearlyWord ?? this.yearlyWord,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
