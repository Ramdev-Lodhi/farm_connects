// sell_state.dart
abstract class SellFormState {}

class SellFormInitial extends SellFormState {
  SellFormInitial();
}

class SellFormSubmitting extends SellFormState {
  SellFormSubmitting();
}

class SellFormSuccess extends SellFormState {
  final String location;
  final String name;
  final String mobile;

  SellFormSuccess({
    required this.location,
    required this.name,
    required this.mobile,
  });


}

class SellFormError extends SellFormState {
  final String errorMessage;

  SellFormError(this.errorMessage);
}
