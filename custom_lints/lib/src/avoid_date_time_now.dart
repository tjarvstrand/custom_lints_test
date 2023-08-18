import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidDateTimeNow extends DartLintRule {
  AvoidDateTimeNow() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_date_time_now',
    problemMessage: "Don't use DateTime.now(), use clock.now() instead",
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) =>
      context.registry.addConstructorName((node) {
        if (node.type.element?.name == 'DateTime' && node.name?.name == 'now') {
          reporter.reportErrorForNode(code, node);
        }
      });
}
