class User {
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String address;
  final String phone;

  User({
    required this.email,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'phone': phone,
    };
  }
}
