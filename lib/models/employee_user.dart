class EmployeeUser {
  final String id;
  final String fullName;
  final String email;
  final String stationId;
  final bool isAdmin;

  EmployeeUser(
      {this.id, this.fullName, this.email, this.stationId, this.isAdmin});

  factory EmployeeUser.fromMap(Map<String, dynamic> data) {
    return EmployeeUser(
        id: data['id'],
        email: data['email'],
        fullName: data['fullName'],
        stationId: data['stationId'],
        isAdmin: data['isAdmin']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "fullName": fullName,
      "isAdmin": isAdmin,
    };
  }
}
