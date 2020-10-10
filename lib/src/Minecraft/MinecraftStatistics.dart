/// Stores Minecraft Sale Statistics.
class MinecraftStatistics {
  int _total, _last24h;
  double _salesPerSecond;

  MinecraftStatistics._();
  
  factory MinecraftStatistics.fromJson(Map response) => MinecraftStatistics._()
    .._total = response['total']
    .._last24h = response['last24h']
    .._salesPerSecond = response['saleVelocityPerSeconds'];

  int get getTotalSales => _total;

  int get getSalesLast24h => _last24h;

  double get getSalesPerSecond => _salesPerSecond;

  @override
  String toString() => 'Total Sales: $_total, Sales Last 24h: $_last24h, Sales per second: $_salesPerSecond';
}

/// Statistics items that can be selected.
enum MinecraftStatisticsItem {
  MinecraftItemsSold,
  MinecraftPrepaidCardsRedeemed,
  CobaltItemsSold,
  ScrollsItemsSold,
  CobaltPrepaidCardsRedeemed,
  DungeonsItemsSold,
}

/// Extension on MinecraftStatisticsItem to give each enum value a string value.
extension MinecraftStatisticsItemExt on MinecraftStatisticsItem {
  String get name {
    switch (this) {
      case MinecraftStatisticsItem.MinecraftItemsSold: return 'item_sold_minecraft';
      case MinecraftStatisticsItem.MinecraftPrepaidCardsRedeemed: return 'prepaid_card_redeemed_minecraft';
      case MinecraftStatisticsItem.CobaltItemsSold: return 'item_sold_cobalt';
      case MinecraftStatisticsItem.ScrollsItemsSold: return 'item_sold_scrolls';
      case MinecraftStatisticsItem.CobaltPrepaidCardsRedeemed: return 'prepaid_card_redeemed_cobalt';
      case MinecraftStatisticsItem.DungeonsItemsSold: return 'item_sold_dungeons';
      default: return null;
    }
  }
}
