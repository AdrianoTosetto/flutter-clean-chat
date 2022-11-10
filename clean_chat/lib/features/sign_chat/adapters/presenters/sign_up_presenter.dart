import 'dart:async';

import 'package:clean_chat/features/shared/adapters/presenters/view_model.dart';
import 'package:clean_chat/features/shared/domain/entities/user.dart';
import 'package:clean_chat/features/shared/domain/error.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_up_input_port.dart';
import 'package:clean_chat/features/sign_chat/domain/usecases/sign_up/sign_up_output_port.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class SignUpPresenter extends SignUpOutputBondary {
  bool nameAlreadyTaken = false;
  bool success = false;
  StreamController<String> navigationStream = StreamController<String>();
  set navigateNext(String route) => navigationStream.sink.add(route);

  final String nameAlreadyTakenError = 'Error already taken';
  final String successSignUp = 'You have been successfully signed up';

  final SignUpViewModel viewModel = SignUpViewModel(
      signUpViewModelDS: SignUpViewModelDS(
    textInputColor: Colors.black,
    signResponseMessage: '',
    hasSignUpMessage: false,
    submitDisabled: false,
  ));

  void present(Either<DomainError, User> result) {
    viewModel.hasSignUpMessage = true;
    if (result.isRight()) {
      viewModel.signResponseMessage = 'Success';
      navigationStream.sink.add('home');
    } else {
      var error = (result as Left<DomainError, User>).value;
      if (error is NameAlreadyTaken) {
        viewModel.signResponseMessage = 'Name already in use';
      }

      if (error is LengthError) {
        viewModel.signResponseMessage = 'Name must be at least 8';
      }
    }
  }

  @override
  void consume(ReturnType data) {
    present(data);
  }
}

class SignUpViewModel extends ViewModel<SignUpViewModelDS> {
  SignUpViewModel({required this.signUpViewModelDS}) : super(signUpViewModelDS);

  final SignUpViewModelDS signUpViewModelDS;

  set textInputColor(Color _textInputColor) {
    signUpViewModelDS.textInputColor = _textInputColor;
    notifyListeners();
  }

  set signResponseMessage(String _signResponseMessage) {
    signUpViewModelDS.signResponseMessage = _signResponseMessage;
    notifyListeners();
  }

  set hasSignUpMessage(bool _hasSignUpMessage) {
    signUpViewModelDS.hasSignUpMessage = _hasSignUpMessage;
    notifyListeners();
  }

  set submitDisabled(bool _submitDisabled) {
    signUpViewModelDS.submitDisabled = _submitDisabled;
    notifyListeners();
  }
}

class SignUpViewModelDS {
  Color textInputColor;
  String signResponseMessage;
  bool hasSignUpMessage;
  bool submitDisabled;

  SignUpViewModelDS({
    required this.textInputColor,
    required this.signResponseMessage,
    required this.hasSignUpMessage,
    required this.submitDisabled,
  });
}
