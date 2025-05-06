// Stored locally and refreshed on updates
enum Languages {
  ptBr(0, 'pt-BR'),
  enUs(1, 'en-US');

  final int id;
  final String acronym;
  const Languages(this.id, this.acronym);

  static List<String> acronyms() {
    return Languages.values.map((lang) => lang.acronym).toList();
  }
}