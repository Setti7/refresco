import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:refresco/core/enums/enums.dart';
import 'package:refresco/core/models/order.dart';
import 'package:refresco/core/models/user.dart';
import 'package:refresco/core/viewModels/views/finish_registration_model.dart';
import 'package:refresco/ui/theme.dart';
import 'package:refresco/ui/views/base_view.dart';

/// [FinishRegistrationView] is used to complete the [User] information that is
/// missing for placing an [Order].
///
/// Receives a [User] instance as parameter to initialize the fields values.
class FinishRegistrationView extends StatelessWidget {
  final User user;

  const FinishRegistrationView(this.user);

  @override
  Widget build(BuildContext context) {
    return BaseView<FinishRegistrationModel>(
      onModelReady: (model) => model.user = user,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: model.assesPop,
          child: Scaffold(
            appBar: AppBar(title: Text('Finalizar registro')),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: AppThemes.themeData
                          .copyWith(canvasColor: Colors.white70),
                      child: PageTransitionSwitcher(
                        duration: const Duration(milliseconds: 300),
                        reverse: model.reverse,
                        transitionBuilder: (
                          Widget child,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return SharedAxisTransition(
                            child: child,
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                          );
                        },
                        child: renderStep(context, model),
                      ),
                    ),
                  ),
                  Divider(height: 0, thickness: 1),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        constraints: BoxConstraints.tightForFinite(
                            width: constraints.maxWidth),
                        color: Colors.white70,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(
                            vertical:
                                model.state == ViewState.idle ? 24.0 : 16.0,
                          ),
                          onPressed: model.state == ViewState.idle
                              ? model.nextStep
                              : () {},
                          child: model.state == ViewState.idle
                              ? Text(
                                  model.currentStep == 2
                                      ? 'FINALIZAR'
                                      : 'CONTINUAR',
                                )
                              : CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget renderStep(BuildContext context, FinishRegistrationModel model) {
    if (model.currentStep == 0) {
      return _StepOne(model);
    } else if (model.currentStep == 1) {
      return _StepTwo(model);
    } else if (model.currentStep == 2) {
      return _StepThree(model);
    } else {
      model.reset();
      return _StepOne(model);
    }
  }
}

class _StepOne extends StatelessWidget {
  final FinishRegistrationModel model;

  const _StepOne(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Qual seu nome?',
            style: Theme.of(context).textTheme.headline5,
          ),
          _InputField(
            label: 'Nome completo',
            errorMessage: model.errorMessage,
            controller: model.fullNameController,
          ),
        ],
      ),
    );
  }
}

class _StepTwo extends StatelessWidget {
  final FinishRegistrationModel model;

  const _StepTwo(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Qual seu telefone?',
            style: Theme.of(context).textTheme.headline5,
          ),
          _InputField(
            label: 'Telefone',
            errorMessage: model.errorMessage,
            controller: model.cellphoneController,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class _StepThree extends StatelessWidget {
  final FinishRegistrationModel model;

  const _StepThree(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Qual seu CPF?',
            style: Theme.of(context).textTheme.headline5,
          ),
          _InputField(
            label: 'CPF',
            errorMessage: model.errorMessage,
            controller: model.cpfController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    Key key,
    @required this.label,
    @required this.controller,
    this.errorMessage,
    this.keyboardType,
  }) : super(key: key);

  final String label;
  final String errorMessage;
  final TextInputType keyboardType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 32),
        ClipRRect(
          borderRadius: AppShapes.cardBorderRadius,
          child: TextFormField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              labelText: label,
              labelStyle: AppFonts.boldPlainHeadline6,
              filled: true,
              fillColor: AppColors.primary[50],
              border: InputBorder.none,
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: errorMessage == null ? 0 : 1,
          duration: Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 8),
            child: Text(
              errorMessage ?? '',
              style: AppFonts.normalPlainHeadline6Smaller,
            ),
          ),
        ),
      ],
    );
  }
}
