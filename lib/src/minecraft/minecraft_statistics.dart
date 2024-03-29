/// Stores Minecraft Sale Statistics.
class MinecraftStatistics {
  final int _total, _last24h;
  final double _salesPerSecond;

  MinecraftStatistics()
      : _total = 0,
        _last24h = 0,
        _salesPerSecond = 0;

  /// The total amount of sales since release.
  int get totalSales => _total;

  /// The total amount of sales in the last 24 hours.
  int get salesLast24h => _last24h;

  /// The amount of sales per second in the last 24 hours.
  double get salesPerSecond => _salesPerSecond;

  @override
  String toString() =>
      'Total Sales: $_total, Sales Last 24h: $_last24h, Sales per second: $_salesPerSecond';
}

/// Statistics items that can be selected.
enum MinecraftStatisticsItem {
  /// The total amount of Minecraft Sales.
  minecraftItemsSold,

  minecraftPrepaidCardsRedeemed,

  /// The total amount of Cobalt Sales.
  cobaltItemsSold,

  /// The total amount of Scrolls Sales.
  scrollsItemsSold,

  cobaltPrepaidCardsRedeemed,

  /// The total amount of Minecraft: Dungeons Sales.
  dungeonsItemsSold,
}

/// Extension on MinecraftStatisticsItem to give each enum value a string value.
extension MinecraftStatisticsItemExt on MinecraftStatisticsItem {
  /// Returns the API version of this item.
  String? get name {
    switch (this) {
      case MinecraftStatisticsItem.minecraftItemsSold:
        return 'item_sold_minecraft';
      case MinecraftStatisticsItem.minecraftPrepaidCardsRedeemed:
        return 'prepaid_card_redeemed_minecraft';
      case MinecraftStatisticsItem.cobaltItemsSold:
        return 'item_sold_cobalt';
      case MinecraftStatisticsItem.scrollsItemsSold:
        return 'item_sold_scrolls';
      case MinecraftStatisticsItem.cobaltPrepaidCardsRedeemed:
        return 'prepaid_card_redeemed_cobalt';
      case MinecraftStatisticsItem.dungeonsItemsSold:
        return 'item_sold_dungeons';
      default:
        return null;
    }
  }
}
