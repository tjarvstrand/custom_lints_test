import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';


PluginBase createPlugin() => _ExampleLinter();

class _ExampleLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [MyLint()];
}

class MyLint extends DartLintRule {
  MyLint() : super(code: _code);

  static const _code = LintCode(
    name: 'my_lint',
    problemMessage: "Some error",
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) =>
      context.registry.addConstructorName((node) {
        if (node.type.element?.name == 'DateTime' && node.name?.name == 'now') {
          reporter.reportErrorForNode(code, node);
        }
      });
}