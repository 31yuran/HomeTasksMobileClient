import 'package:home_task/fetch_data/task_servies.dart';
import 'package:home_task/fetch_data/user.dart';
import 'package:home_task/enums.dart' as enums;

final TaskServies taskServies = TaskServies();

User _currentUser;
User get currentUser => _currentUser;
set currentUser(User val) {
  _currentUser = val;
  if (_currentUser.role == null) _currentUser.role = enums.UserRole.master;
  if (_currentUser != null)
    taskServies.savePref("userId", _currentUser.id.toString());
}
