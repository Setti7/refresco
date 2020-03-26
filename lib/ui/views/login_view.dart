import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/core/enums/enums.dart';
import 'package:flutter_base/core/viewModels/login_model.dart';
import 'package:flutter_base/ui/theme.dart';
import 'package:flutter_base/ui/views/base_view.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginModel>(
      builder: (context, model, child) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('refresco',
                        style: TextStyle(
                            fontSize: 56,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w300)),
                    Text('Delivery de água',
                        style: AppThemes.boldPlainHeadline6),
                    SizedBox(height: 56),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        borderRadius: AppShapes.inputBorderRadius,
                      ),
                      child: TextFormField(
                        controller: model.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.07),
                        borderRadius: AppShapes.inputBorderRadius,
                      ),
                      child: TextFormField(
                        controller: model.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !model.signIn,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.07),
                              borderRadius: AppShapes.inputBorderRadius,
                            ),
                            child: TextFormField(
                              controller: model.confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirmar senha',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Criar conta',
                              style: AppThemes.boldPlainHeadline6),
                          Switch(
                            onChanged: (value) => model.changeAction(value),
                            value: !model.signIn,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(model.errorMessage ?? '',
                              style: AppThemes.boldPlainHeadline6),
                        ),
                        SizedBox(height: 8),
                        RaisedButton(
                          onPressed: model.state == ViewState.busy ? () {} : () {
                            if (model.signIn) {
                              model.loginWithEmail(context);
                            } else {
                              model.createUser(context);
                            }
                          },
                          child: model.state == ViewState.idle
                              ? Text(model.signIn ? 'ENTRAR' : 'CRIAR CONTA')
                              : CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
