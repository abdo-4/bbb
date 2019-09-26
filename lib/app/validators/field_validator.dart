class EmailValidator {
	static final RegExp regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
}

class UserNameValidator {
	static final RegExp regex = new RegExp(r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,})');
}

class PhoneValidator {
	static final RegExp regex = new RegExp(r'(([0-9]+\.)+[a-zA-Z]{2,})');
}