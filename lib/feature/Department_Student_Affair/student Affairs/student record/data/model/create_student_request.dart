class CreateStudentRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String nationalNumber;
  final String fingerprintId;
  final String fatherName;
  final String motherName;
  final String dob;
  final String placeOfBirth;
  final String registryPlaceNum;
  final String address;
  final int governorateId;
  final int nationalId;
  final String mobileNum;
  final String studyType;
  final String housingType;
  final int academicYearId;

  CreateStudentRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.nationalNumber,
    required this.fingerprintId,
    required this.fatherName,
    required this.motherName,
    required this.dob,
    required this.placeOfBirth,
    required this.registryPlaceNum,
    required this.address,
    required this.governorateId,
    required this.nationalId,
    required this.mobileNum,
    required this.studyType,
    required this.housingType,
    required this.academicYearId,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'national_number': nationalNumber,
      'fingerprint_id': fingerprintId,
      'father_name': fatherName,
      'mother_name': motherName,
      'dob': dob,
      'place_of_birth': placeOfBirth,
      'registry_place_num': registryPlaceNum,
      'address': address,
      'governorate_id': governorateId,
      'national_id': nationalId,
      'mobile_num': mobileNum,
      'study_type': studyType,
      'housing_type': housingType,
      'acadmic_year_id': academicYearId,
    };
  }
}