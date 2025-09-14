import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final int coins;
  final bool hasUnlockedTestSeries;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.coins,
    required this.hasUnlockedTestSeries,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel from a Firestore DocumentSnapshot
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      coins: data['coins'] ?? 0,
      hasUnlockedTestSeries: data['hasUnlockedTestSeries'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert a UserModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'coins': coins,
      'hasUnlockedTestSeries': hasUnlockedTestSeries,
      'createdAt': createdAt,
    };
  }

  // Helper method to create a copy of the user model with updated values
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatarUrl,
    int? coins,
    bool? hasUnlockedTestSeries,
    Timestamp? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coins: coins ?? this.coins,
      hasUnlockedTestSeries: hasUnlockedTestSeries ?? this.hasUnlockedTestSeries,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
