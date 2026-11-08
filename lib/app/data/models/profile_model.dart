class ProfileModel {
  const ProfileModel({
    this.childName = '',
    this.avatarPath = '',
    this.phoneNumber = '',
    this.address = '',
  });

  const ProfileModel.empty()
    : childName = '',
      avatarPath = '',
      phoneNumber = '',
      address = '';

  factory ProfileModel.fromMap(Map<String, dynamic> data) {
    final Object? childName = data['childName'] ?? data['name'];
    final Object? avatarPath =
        data['photoUrl'] ??
        data['imageUrl'] ??
        data['avatarPath'] ??
        data['photoPath'];
    final Object? phoneNumber = data['phoneNumber'];
    final Object? address = data['address'];
    return ProfileModel(
      childName: childName is String ? childName.trim() : '',
      avatarPath: avatarPath is String ? avatarPath.trim() : '',
      phoneNumber: phoneNumber is String ? phoneNumber.trim() : '',
      address: address is String ? address.trim() : '',
    );
  }

  final String childName;
  final String avatarPath;
  final String phoneNumber;
  final String address;

  String get displayedChildName => childName.isEmpty ? 'اسم الطفل' : childName;

  String get displayedPhoneNumber =>
      phoneNumber.isEmpty ? 'غير محدد' : phoneNumber;

  String get displayedAddress => address.isEmpty ? 'غير محدد' : address;

  ProfileModel copyWith({String? childName, String? avatarPath}) {
    return ProfileModel(
      childName: childName ?? this.childName,
      avatarPath: avatarPath ?? this.avatarPath,
      phoneNumber: phoneNumber,
      address: address,
    );
  }
}
