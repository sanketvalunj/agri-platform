import 'dart:convert';

class UserProfile {
  final String id;
  final String name;
  final String location;
  final String phone;
  final String bio;
  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Farm Information
  final double farmArea;
  final String farmAreaUnit;
  final List<String> cropTypes;
  final String farmingType;
  final String irrigation;
  final String soilType;
  final int farmingExperience;
  // Verification & Trust
  final String verificationStatus;
  final int trustScore;
  final String accountStatus;
  final DateTime? verificationDate;
  final DateTime? lastCarbonUpdate;
  // Verification Details
  final bool satelliteDataVerified;
  final bool activityPhotosSubmitted;
  final bool seasonalValidationPending;
  final bool identityVerified;

  UserProfile({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.bio,
    required this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    // Farm Information
    this.farmArea = 0.0,
    this.farmAreaUnit = 'Acres',
    this.cropTypes = const [],
    this.farmingType = '',
    this.irrigation = '',
    this.soilType = '',
    this.farmingExperience = 0,
    // Verification & Trust
    this.verificationStatus = 'Pending',
    this.trustScore = 0,
    this.accountStatus = 'Active',
    this.verificationDate,
    this.lastCarbonUpdate,
    // Verification Details
    this.satelliteDataVerified = false,
    this.activityPhotosSubmitted = false,
    this.seasonalValidationPending = false,
    this.identityVerified = false,
  });

  // Create empty profile with current timestamp
  factory UserProfile.empty() {
    final now = DateTime.now();
    return UserProfile(
      id: '',
      name: '',
      location: '',
      phone: '',
      bio: '',
      profileImageUrl: '',
      createdAt: now,
      updatedAt: now,
      // Farm Information defaults
      farmArea: 0.0,
      farmAreaUnit: 'Acres',
      cropTypes: [],
      farmingType: '',
      irrigation: '',
      soilType: '',
      farmingExperience: 0,
      // Verification & Trust defaults
      verificationStatus: 'Pending',
      trustScore: 0,
      accountStatus: 'Active',
      verificationDate: null,
      lastCarbonUpdate: null,
      // Verification Details defaults
      satelliteDataVerified: false,
      activityPhotosSubmitted: false,
      seasonalValidationPending: false,
      identityVerified: false,
    );
  }

  // Create profile with default values
  factory UserProfile.defaultProfile() {
    final now = DateTime.now();
    return UserProfile(
      id: 'default_user',
      name: 'Agri User',
      location: '',
      phone: '',
      bio: '',
      profileImageUrl: '',
      createdAt: now,
      updatedAt: now,
      // Farm Information defaults
      farmArea: 0.0,
      farmAreaUnit: 'Acres',
      cropTypes: [],
      farmingType: '',
      irrigation: '',
      soilType: '',
      farmingExperience: 0,
      // Verification & Trust defaults
      verificationStatus: 'Pending',
      trustScore: 0,
      accountStatus: 'Active',
      verificationDate: null,
      lastCarbonUpdate: null,
      // Verification Details defaults
      satelliteDataVerified: false,
      activityPhotosSubmitted: false,
      seasonalValidationPending: false,
      identityVerified: false,
    );
  }

  // Create profile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      // Farm Information
      farmArea: (json['farmArea'] ?? 0.0).toDouble(),
      farmAreaUnit: json['farmAreaUnit'] ?? 'Acres',
      cropTypes: List<String>.from(json['cropTypes'] ?? []),
      farmingType: json['farmingType'] ?? '',
      irrigation: json['irrigation'] ?? '',
      soilType: json['soilType'] ?? '',
      farmingExperience: json['farmingExperience'] ?? 0,
      // Verification & Trust
      verificationStatus: json['verificationStatus'] ?? 'Pending',
      trustScore: json['trustScore'] ?? 0,
      accountStatus: json['accountStatus'] ?? 'Active',
      verificationDate: json['verificationDate'] != null
          ? DateTime.parse(json['verificationDate'])
          : null,
      lastCarbonUpdate: json['lastCarbonUpdate'] != null
          ? DateTime.parse(json['lastCarbonUpdate'])
          : null,
      // Verification Details
      satelliteDataVerified: json['satelliteDataVerified'] ?? false,
      activityPhotosSubmitted: json['activityPhotosSubmitted'] ?? false,
      seasonalValidationPending: json['seasonalValidationPending'] ?? false,
      identityVerified: json['identityVerified'] ?? false,
    );
  }

  // Convert profile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phone': phone,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      // Farm Information
      'farmArea': farmArea,
      'farmAreaUnit': farmAreaUnit,
      'cropTypes': cropTypes,
      'farmingType': farmingType,
      'irrigation': irrigation,
      'soilType': soilType,
      'farmingExperience': farmingExperience,
      // Verification & Trust
      'verificationStatus': verificationStatus,
      'trustScore': trustScore,
      'accountStatus': accountStatus,
      'verificationDate': verificationDate?.toIso8601String(),
      'lastCarbonUpdate': lastCarbonUpdate?.toIso8601String(),
      // Verification Details
      'satelliteDataVerified': satelliteDataVerified,
      'activityPhotosSubmitted': activityPhotosSubmitted,
      'seasonalValidationPending': seasonalValidationPending,
      'identityVerified': identityVerified,
    };
  }

  // Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? location,
    String? phone,
    String? bio,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Farm Information
    double? farmArea,
    String? farmAreaUnit,
    List<String>? cropTypes,
    String? farmingType,
    String? irrigation,
    String? soilType,
    int? farmingExperience,
    // Verification & Trust
    String? verificationStatus,
    int? trustScore,
    String? accountStatus,
    DateTime? verificationDate,
    DateTime? lastCarbonUpdate,
    // Verification Details
    bool? satelliteDataVerified,
    bool? activityPhotosSubmitted,
    bool? seasonalValidationPending,
    bool? identityVerified,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt:
          updatedAt ?? DateTime.now(), // Always update timestamp when modified
      // Farm Information
      farmArea: farmArea ?? this.farmArea,
      farmAreaUnit: farmAreaUnit ?? this.farmAreaUnit,
      cropTypes: cropTypes ?? this.cropTypes,
      farmingType: farmingType ?? this.farmingType,
      irrigation: irrigation ?? this.irrigation,
      soilType: soilType ?? this.soilType,
      farmingExperience: farmingExperience ?? this.farmingExperience,
      // Verification & Trust
      verificationStatus: verificationStatus ?? this.verificationStatus,
      trustScore: trustScore ?? this.trustScore,
      accountStatus: accountStatus ?? this.accountStatus,
      verificationDate: verificationDate ?? this.verificationDate,
      lastCarbonUpdate: lastCarbonUpdate ?? this.lastCarbonUpdate,
      // Verification Details
      satelliteDataVerified:
          satelliteDataVerified ?? this.satelliteDataVerified,
      activityPhotosSubmitted:
          activityPhotosSubmitted ?? this.activityPhotosSubmitted,
      seasonalValidationPending:
          seasonalValidationPending ?? this.seasonalValidationPending,
      identityVerified: identityVerified ?? this.identityVerified,
    );
  }

  // Check if profile is complete (has essential info)
  bool get isComplete {
    return name.isNotEmpty && location.isNotEmpty && farmArea > 0;
  }

  // Get trust score level
  String get trustScoreLevel {
    if (trustScore >= 80) return 'High';
    if (trustScore >= 50) return 'Medium';
    return 'Low';
  }

  // Get verification status display
  String get verificationStatusDisplay {
    switch (verificationStatus) {
      case 'Verified':
        return 'Verified Farmer';
      case 'Pending':
        return 'Verification in Progress';
      case 'Rejected':
        return 'Verification Failed';
      default:
        return 'Verification Pending';
    }
  }

  // Get confidence level text
  String get confidenceLevel {
    if (trustScore >= 80) return 'High';
    if (trustScore >= 60) return 'Medium';
    return 'Low';
  }

  // Get carbon credits (placeholder for now)
  double get carbonCredits {
    // This would typically be calculated based on farm data
    // For now, return a placeholder based on farm area
    return (farmArea * 0.5).clamp(0.0, 10.0);
  }

  // Get primary crop (first in the list or empty)
  String get primaryCrop {
    return cropTypes.isNotEmpty ? cropTypes.first : '';
  }

  // Get formatted farm area
  String get formattedFarmArea {
    if (farmArea == 0) return 'Not set';
    return '$farmArea $farmAreaUnit';
  }

  // Get farming experience display
  String get farmingExperienceDisplay {
    if (farmingExperience == 0) return 'Not set';
    return '$farmingExperience years';
  }

  // Get last carbon update display
  String get lastCarbonUpdateDisplay {
    if (lastCarbonUpdate == null) return 'Never';
    final now = DateTime.now();
    final difference = now.difference(lastCarbonUpdate!);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }

  // Get display name (fallback to default if empty)
  String get displayName {
    return name.isNotEmpty ? name : 'User';
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.phone == phone &&
        other.bio == bio &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, location, phone, bio, profileImageUrl);
  }
}
