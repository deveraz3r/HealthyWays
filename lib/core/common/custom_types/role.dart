enum Role {
  // admin,
  doctor,
  patient,
  pharmacist,
}

extension RoleExtension on Role {
  String toJson() {
    return name;
  }

  static Role fromJson(String value) {
    return Role.values.firstWhere((role) => role.name == value);
  }

  // static Role fromJson(String json) {
  //   switch (json.toLowerCase()) {
  //     case 'doctor':
  //       return Role.doctor;
  //     case 'patient':
  //       return Role.patient;
  //     case 'pharmacist':
  //       return Role.pharmacist;
  //     default:
  //       throw Exception('Invalid role: $json');
  //   }
  // }
}
