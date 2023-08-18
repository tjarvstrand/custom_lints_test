import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AvoidLiteralStrings extends DartLintRule {
  AvoidLiteralStrings() : super(code: _code);

  static const _code = LintCode(
    name: 'avoid_literal_strings',
    problemMessage: "Don't use literal strings, add them to localized messages instead.",
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    if (!resolver.path.contains('lib/presentation')) return;
    context.registry.addStringLiteral((node) {
      if (_isDebugFillProperties(node) ||
          _isDirective(node) ||
          node.length == 2 ||
          _isAllowedCall(node) ||
          _isNonAlphabetic(node)) return;

      reporter.reportErrorForNode(code, node);
    });
  }

  bool _isAllowedCall(AstNode node) {
    final parentLexeme = node.parent?.parent?.beginToken.lexeme;
    return parentLexeme?.endsWith('Failure') == true ||
        parentLexeme?.endsWith('Error') == true ||
        parentLexeme == 'Logger' ||
        parentLexeme == 'RegExp';
  }

  static final _letterRegexp = RegExp(r'\p{Letter}', unicode: true);

  bool _isNonAlphabetic(AstNode node) => !_letterRegexp.hasMatch(node.toSource());

  bool _isDirective(AstNode node) => node.findPrevious(node.beginToken)?.isTopLevelKeyword == true;

  bool _isDebugFillProperties(AstNode node) {
    var parent = node.parent;
    while (parent != null) {
      final source = parent.toSource();
      if (source.startsWith('@override void debugFillProperties') || source.startsWith('void debugFillProperties')) {
        return true;
      }
      parent = parent.parent;
    }
    return false;
  }
}
