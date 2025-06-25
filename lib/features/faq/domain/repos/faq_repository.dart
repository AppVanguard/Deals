import '../models/faq_document.dart';

abstract class FaqRepository {
  Future<FaqDocument> loadFaq();
}
