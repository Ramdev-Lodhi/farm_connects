  // sell_state.dart
  abstract class SellFormState {}
  class SellFormInitial extends SellFormState {
    SellFormInitial();
  }
  class SellFormLoading extends SellFormState {
    SellFormLoading();
  }
  class SellFormSubmitting extends SellFormState {
    SellFormSubmitting();
  }

  class SellMultiFormSubmitting extends SellFormState {}

  class SellFormSuccess extends SellFormState {}

  class SellFormError extends SellFormState {
    final String errorMessage;
    SellFormError(this.errorMessage);
  }