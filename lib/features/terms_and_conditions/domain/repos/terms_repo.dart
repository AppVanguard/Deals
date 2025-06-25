import 'package:deals/features/terms_and_conditions/domain/models/terms_document.dart';

abstract class TermsRepo {
  Future<TermsDocument> loadTerms();
}
