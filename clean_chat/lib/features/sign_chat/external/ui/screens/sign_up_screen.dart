import 'package:clean_chat/features/shared/adapters/controllers/event_handler.dart';
import 'package:clean_chat/features/shared/external/ui/mixins/navigator_manager.dart';
import 'package:clean_chat/features/sign_chat/adapters/controllers/sign_up_controller.dart';
import 'package:clean_chat/features/sign_chat/adapters/presenters/sign_up_presenter.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key, required this.controller, required this.presenter})
      : super(key: key);

  EventHandler controller;
  SignUpPresenter presenter;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with NavigatorManager {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handle(widget.presenter.navigationStream, context);
  }

  Widget _signUpForm(SignUpViewModelDS viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          cursorWidth: 2,
          controller: _textEditingController,
          decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 8)),
          style: TextStyle(),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: () {
            widget.presenter.viewModel.hasSignUpMessage = false;
            widget.presenter.viewModel.signResponseMessage = '';
            String name = _textEditingController.text;
            widget.controller.handle(SignUpEvent(userName: name));
          },
          child: const Text('Sign up'),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(viewModel.signResponseMessage),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFAFB),
        body: ValueListenableBuilder(
          valueListenable: widget.presenter.viewModel,
          builder: (BuildContext context, SignUpViewModelDS viewModel, _) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _signUpForm(viewModel),
            ));
          },
        ),
      ),
    );
  }
}
