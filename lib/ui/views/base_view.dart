import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refresco/core/viewModels/base_model.dart';
import 'package:refresco/locator.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final Function(T) onModelReady;
  final Widget child;

  BaseView({@required this.builder, this.onModelReady, this.child});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
