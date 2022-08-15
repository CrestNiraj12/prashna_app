bool validateEmail(String value) {
  String pattern =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

bool validatePassword(String value) {
  // String pattern =
  //     r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
  // RegExp regex = new RegExp(pattern);
  // return regex.hasMatch(value);
  return value.length >= 8;
}

bool validateUsername(String value) {
  String pattern = r"^(?=.*[A-Za-z])[A-Za-z\d]{6,}$";
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
