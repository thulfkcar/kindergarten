class LoginFormData {
  String email = '';
  String password = '';
}

class EditUserForm {
  String userName;

  EditUserForm({required this.userName});
}

class AddUserForm {
  String userName;
  String password;

  String role;

  AddUserForm({required this.userName,required this.password, required this.role});
}
class LoginForm{
  String? phoneNumber;


}
class SignUpForm{
  String? phoneNumber;
  String? fullName;


}