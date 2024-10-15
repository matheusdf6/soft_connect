/// Status de conexão com a rede, indicando em qual rede está conectado ou se
/// não está conectada à nenhuma
enum ConnectionStatus {
  /// Conectado via Wi-Fi
  wifi('wifi'),

  /// Conectada via redes móveis (3G, 4G, 5G)
  mobile('mobile'),

  /// Conectada via outra rede desconhecida
  other('other'),

  /// Desconectado
  none(null);

  const ConnectionStatus(this.tag);

  final String? tag;

  factory ConnectionStatus.withCode(String? tag) {
    final result = ConnectionStatus.values.where((status) => status.tag == tag);
    return result.isNotEmpty ? result.first : none;
  }
}
