import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final String cancelButtonTitle;
  final AlertType type;
  final Widget content;

  AlertRequest({
    @required this.title,
    @required this.description,
    @required this.buttonTitle,
    this.cancelButtonTitle,
    this.type,
    this.content,
  });
}
