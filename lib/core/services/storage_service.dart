class UserAccount {
  const UserAccount({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class AuthStorage {
  AuthStorage._();

  static final AuthStorage instance = AuthStorage._();

  final List<UserAccount> _users = <UserAccount>[];
  UserAccount? _currentUser;

  List<UserAccount> get users => List<UserAccount>.unmodifiable(_users);

  UserAccount? get currentUser => _currentUser;

  String? get currentUserName => _currentUser?.name;

  bool registerUser({
    required String name,
    required String email,
    required String password,
  }) {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password;

    if (normalizedName.isEmpty ||
        normalizedEmail.isEmpty ||
        normalizedPassword.isEmpty) {
      return false;
    }

    final alreadyExists = _users.any(
      (user) => user.email.trim().toLowerCase() == normalizedEmail,
    );
    if (alreadyExists) {
      return false;
    }

    _users.add(
      UserAccount(
        name: normalizedName,
        email: normalizedEmail,
        password: normalizedPassword,
      ),
    );
    return true;
  }

  UserAccount? login({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPassword = password;

    for (final user in _users) {
      if (user.email.trim().toLowerCase() == normalizedEmail &&
          user.password == normalizedPassword) {
        _currentUser = user;
        return user;
      }
    }

    return null;
  }

  bool updateCurrentUserName({required String name}) {
    final currentUser = _currentUser;
    final normalizedName = name.trim();
    if (currentUser == null || normalizedName.isEmpty) {
      return false;
    }

    final userIndex = _users.indexOf(currentUser);
    if (userIndex == -1) {
      return false;
    }

    final updatedUser = UserAccount(
      name: normalizedName,
      email: currentUser.email,
      password: currentUser.password,
    );
    _users[userIndex] = updatedUser;
    _currentUser = updatedUser;
    return true;
  }

  void logout() {
    _currentUser = null;
  }
}
