//core cannot depend on other features but vice versa is true
//therefore we have User in common folder of core so that it can be used by app_user cubit

class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}