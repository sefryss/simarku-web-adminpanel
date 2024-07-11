import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  String fullName;
  String nikNumber;
  String phoneNumber;
  String address;
  final String email;
  String profilePicture;
  bool isOnline;
  String lastActive;
  String pushToken;
  bool isAccess;
  bool isAdmin;
  String deviceId;

  UserModel({
    required this.id,
    required this.fullName,
    required this.nikNumber,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.profilePicture,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.isAccess,
    required this.isAdmin,
    required this.deviceId,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? nikNumber,
    String? phoneNumber,
    String? address,
    String? email,
    String? profilePicture,
    bool? isOnline,
    String? lastActive,
    String? pushToken,
    bool? isAccess,
    bool? isAdmin,
    String? deviceId,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      nikNumber: nikNumber ?? this.nikNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      pushToken: pushToken ?? this.pushToken,
      isAccess: isAccess ?? this.isAccess,
      isAdmin: isAdmin ?? this.isAdmin,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  static UserModel empty() => UserModel(
        id: '',
        fullName: '',
        nikNumber: '',
        phoneNumber: '',
        address: '',
        email: '',
        profilePicture: '',
        isOnline: false,
        lastActive: '',
        pushToken: '',
        isAccess: false,
        isAdmin: false,
        deviceId: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FullName': fullName,
      'NIKNumber': nikNumber,
      'PhoneNumber': phoneNumber,
      'Address': address,
      'Email': email,
      'ProfilePicture': profilePicture,
      'IsOnline': isOnline,
      'LastActive': lastActive,
      'PushToken': pushToken,
      'IsAccess': isAccess,
      'IsAdmin': isAdmin,
      'DeviceId': deviceId,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['FullName'] ?? '',
      nikNumber: json['NIKNumber'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      address: json['Address'] ?? '',
      email: json['Email'] ?? '',
      profilePicture: json['ProfilePicture'] ?? '',
      isOnline: json['IsOnline'] ?? false,
      lastActive: json['LastActive'] ?? '',
      pushToken: json['PushToken'] ?? '',
      isAccess: json['IsAccess'] ?? false,
      isAdmin: json['IsAdmin'] ?? false,
      deviceId: json['DeviceId'] ?? '',
    );
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(
        id: document.id,
        fullName: data['FullName'] ?? '',
        nikNumber: data['NIKNumber'] ?? '',
        phoneNumber: data['PhoneNumber'] ?? '',
        address: data['Address'] ?? '',
        email: data['Email'] ?? '',
        profilePicture: data['ProfilePicture'] ?? '',
        isOnline: data['IsOnline'] ?? false,
        lastActive: data['LastActive'] ?? '',
        pushToken: data['PushToken'] ?? '',
        isAccess: data['IsAccess'] ?? false,
        isAdmin: data['IsAdmin'] ?? false,
        deviceId: data['DeviceId'] ?? '',
      );
    } else {
      throw Exception("Document data is null!");
    }
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      id: doc.id,
      address: data['Address'] ?? '',
      email: data['Email'] ?? '',
      fullName: data['FullName'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      nikNumber: data['NIKNumber'] ?? '',
      isOnline: data['IsOnline'] ?? false,
      lastActive: data['LastActive'] ?? '',
      pushToken: data['PushToken'] ?? '',
      isAccess: data['IsAccess'] ?? false,
      isAdmin: data['IsAdmin'] ?? false,
      deviceId: data['DeviceId'] ?? '',
    );
  }

  // Method to fetch user data from Firestore
  static Future<UserModel> fetchCurrentUser() async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        print('User data fetched successfully.');
        return UserModel.fromFirestore(userDoc);
      } else {
        print('User document does not exist.');
        throw 'User document does not exist.';
      }
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }
}
