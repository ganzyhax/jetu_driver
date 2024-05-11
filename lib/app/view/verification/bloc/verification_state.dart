part of 'verification_cubit.dart';

class VerificationState {
  final String phone;
  final Map<String, dynamic> userInfo;
  final File? image1;
  final File? image2;
  final File? image3;
  final bool isLoading;
  final String error;
  final bool success;

  const VerificationState({
    required this.phone,
    required this.userInfo,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.isLoading,
    required this.error,
    required this.success,
  });

  factory VerificationState.initial() => const VerificationState(
        phone: '',
        userInfo: {},
        image1: null,
        image2: null,
        image3: null,
        isLoading: false,
        error: '',
        success: false,
      );

  VerificationState copyWith({
    String? phone,
    Map<String, dynamic>? userInfo,
    File? image1,
    File? image2,
    File? image3,
    bool? isLoading,
    String? error,
    bool? success,
  }) =>
      VerificationState(
        phone: phone ?? this.phone,
        userInfo: userInfo ?? this.userInfo,
        image1: image1 ?? this.image1,
        image2: image2 ?? this.image2,
        image3: image3 ?? this.image3,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        success: success ?? this.success,
      );
}
