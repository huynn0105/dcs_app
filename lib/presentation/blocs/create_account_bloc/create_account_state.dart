// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_account_bloc.dart';

class CreateAccountState {
  final bool loading;
  final bool? success;
  final List<FormTextField> formTextFields;
  final String? message;

  const CreateAccountState({
    this.loading = false,
    this.success,
    this.formTextFields = const [],
    this.message,
  });

  CreateAccountState copyWith({
    bool? loading,
    bool? success,
    List<FormTextField>? formTextFields,
    String? message,
  }) {
    return CreateAccountState(
      loading: loading ?? false,
      success: success,
      formTextFields: formTextFields ?? this.formTextFields,
      message: message ?? this.message,
    );
  }
}

// final class CreateAccountInitial extends CreateAccountState {}

// final class CreateAccountSucceeded extends CreateAccountState {}

// final class CreateAccountFailed extends CreateAccountState {
//   final String message;
//   CreateAccountFailed({
//     required this.message,
//   });
// }

// final class CreateAccountLoading extends CreateAccountState {}

// final class CreateAccountLoaded extends CreateAccountState{
//   final List<FormTextField> formTextFields;

//   CreateAccountLoaded({
//     required this.formTextFields,
//   });

//   List<String> get formFieldNames => formTextFields.map((e) => e.accountDto.name.toLowerCase()).toList();
// }

class FormTextField {
  late TextEditingController controller;
  late GlobalObjectKey<FormState> formKey;
  final RequirementAccountDto accountDto;

  FormTextField({required this.accountDto}) {
    controller = TextEditingController();
    formKey = GlobalObjectKey<FormState>(accountDto);
  }
}
