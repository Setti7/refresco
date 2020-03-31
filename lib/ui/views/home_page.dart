import 'package:flutter/material.dart';
import 'package:flutter_base/core/models/user.dart';
import 'package:flutter_base/core/services/auth_service.dart';
import 'package:flutter_base/core/viewModels/home_page.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  HomePageViewModel viewModel;

  @override
  void didChangeDependencies() {
    viewModel = Provider.of<HomePageViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: viewModel.userObservable),
        StreamProvider.value(value: viewModel.loginStatusObservable),
      ],
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildHeader(),
              _buildLoginButton(),
              buildUserInfoButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInfoButton() {
    return Consumer<LoginStatus>(
      builder: (context, loginStatus, child) {
        return Visibility(
          visible: true,
          child: MaterialButton(
            color: Colors.green,
            child: Text("Get current user info"),
            onPressed: viewModel.getCurrentUserInfo(),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Consumer<User>(
      builder: (context, user, child) {
        if (user == null) return Container();
        return Text("Hello ${user.name}");
      },
    );
  }

  Widget _buildLoginButton() {
    return Consumer<LoginStatus>(
      builder: (context, loginStatus, child) {
        String buttonText;
        if (loginStatus == LoginStatus.loggedIn)
          buttonText = 'Logout';
        else if (loginStatus == LoginStatus.loading)
          buttonText = 'Loading';
        else
          buttonText = "Login";

        return MaterialButton(
          color: Colors.yellow,
          child: Text(buttonText),
          onPressed: loginStatus == LoginStatus.loading
              ? null
              : viewModel.getLoginButtonCallback(),
        );
      },
    );
  }
}
