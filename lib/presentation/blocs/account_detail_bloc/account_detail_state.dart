// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'account_detail_bloc.dart';

class AccountDetailState {
  final bool loading;
  final bool? success;
  final String? message;
  final ClientAccountDetailResponseDto? accountDetail;
  final List<FormTextField> formTextFields;

  const AccountDetailState({
    this.loading = false,
    this.success,
    this.message,
    this.accountDetail,
    this.formTextFields = const [],
  });

  AccountDetailState copyWith({
    bool? loading,
    bool? success,
    String? message,
    ClientAccountDetailResponseDto? accountDetail,
    List<FormTextField>? formTextFields,
  }) {
    return AccountDetailState(
      loading: loading ?? false,
      success: success,
      message: message,
      accountDetail: accountDetail ?? this.accountDetail,
      formTextFields: formTextFields ?? this.formTextFields,
    );
  }
}

class FormTextField {
  late TextEditingController controller;
  late GlobalObjectKey<FormState> formKey;
  final RequirementAccount accountRequirement;

  FormTextField({required this.accountRequirement, required String initValue}) {
    controller = TextEditingController(text: initValue);
    formKey = GlobalObjectKey<FormState>(accountRequirement);
  }
}
