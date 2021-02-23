/// Represents a blocked server that the player 
/// shouldn't be allowed to join.
class BlockedServer {
  /// The SHA1 of the address of the server.
  final String addressSha1;

  /// The adress of the server. Only available
  /// if the server has been 'cracked'.
  final String? address;

  /// A blocked server that the player shouldn't 
  /// be allowed to join
  const BlockedServer(this.addressSha1, this.address);

  /// Parse the [address] and check if it is included in 
  /// [_knownCrackedServers] and if so, add the cracked address
  /// to it.
  factory BlockedServer.parse(String addressSha1) {
    final crackedAddress = _knownCrackedServers.where((server) => server.addressSha1 == addressSha1);
    if (crackedAddress.isEmpty) {
      return BlockedServer(addressSha1, null);
    } else {
      return crackedAddress.first;
    }
  }

  /// Wether the SHA1 of this blocked server has been 
  /// cracked and the actual address is known.
  bool get isCracked => address != null;

  @override
  String toString() {
    return (address != null) ? '$addressSha1:$address' : addressSha1;
  }

  /// A list of blocked servers with actual adresses that have been cracked.
  /// Parsed list from https://wiki.vg/Mojang_API#Blocked_Servers.
  static const List<BlockedServer> _knownCrackedServers = <BlockedServer>[
    BlockedServer('6f2520f8bd70a718c568ab5274c56bdbbfc14ef4', '*.minetime.com'),
    BlockedServer('7ea72de5f8e70a2ac45f1aa17d43f0ca3cddeedd', '*.trollingbrandon.club'),
    BlockedServer('c005ad34245a8f2105658da2d6d6e8545ef0f0de', '*.skygod.us'),
    BlockedServer('c645d6c6430db3069abd291ec13afebdb320714b', '*.mineaqua.es'),
    BlockedServer('8bf58811e6ebca16a01b842ff0c012db1171d7d6', '*.eulablows.host'),
    BlockedServer('8789800277882d1989d384e7941b6ad3dadab430', '*.moredotsmoredots.xyz'),
    BlockedServer('e40c3456fb05687b8eeb17213a47b263d566f179', '*.brandonlovescock.bid'),
    BlockedServer('278b24ffff7f9f46cf71212a4c0948d07fb3bc35', '*.brandonlovescock.club'),        
    BlockedServer('c78697e385bfa58d6bd2a013f543cdfbdc297c4f', '*.mineaqua.net'),
    BlockedServer('b13009db1e2fbe05465716f67c8d58b9c0503520', '*.endercraft.com'),
    BlockedServer('3e560742576af9413fca72e70f75d7ddc9416020', '*.insanefactions.org'),
    BlockedServer('986204c70d368d50ffead9031e86f2b9e70bb6d0', '*.playmc.mx'),
    BlockedServer('65ca8860fa8141da805106c0389de9d7c17e39bf', '*.howdoiblacklistsrv.host'),      
    BlockedServer('7dca807cc9484b1eed109c003831faf189b6c8bf', '*.brandonlovescock.online'),      
    BlockedServer('c6a2203285fb0a475c1cd6ff72527209cc0ccc6e', '*.brandonlovescock.press'),       
    BlockedServer('e3985eb936d66c9b07aa72c15358f92965b1194e', '*.insanenetwork.org'),
    BlockedServer('b140bec2347bfbe6dcae44aa876b9ba5fe66505b', '*.phoenixnexus.net'),
    BlockedServer('27ae74becc8cd701b19f25d347faa71084f69acd', '*.arkhamnetwork.org'),
    BlockedServer('48f04e89d20b15de115503f22fedfe2cb2d1ab12', 'brandonisan.unusualperson.com'),  
    BlockedServer('9f0f30820cebb01f6c81f0fdafefa0142660d688', '*.kidslovemy500dollarranks.club'),
    BlockedServer('cc90e7b39112a48064f430d3a08bbd78a226d670', '*.eccgamers.com'),
    BlockedServer('88f155cf583c930ffed0e3e69ebc3a186ea8cbb7', '*.fucktheeula.com'),
    BlockedServer('605e6296b8dba9f0e4b8e43269fe5d053b5f4f1b', '*.mojangendorsesbrazzers.webcam'),
    BlockedServer('5d2e23d164a43fbfc4e6093074567f39b504ab51', 'touchmybody.redirectme.net'),     
    BlockedServer('f3df314d1f816a8c2185cd7d4bcd73bbcffc4ed8', '*.mojangsentamonkeyinto.space'),  
    BlockedServer('073ca448ef3d311218d7bd32d6307243ce22e7d0', '*.diacraft.org'),
    BlockedServer('33839f4006d6044a3a6675c593fada6a690bb64d', '*.diacraft.de'),
    BlockedServer('e2e12f3b7b85eab81c0ee5d2e9e188df583fe281', '*.eulablacklist.club'),
    BlockedServer('11a2c115510bfa6cb56bbd18a7259a4420498fd5', '*.slaughterhousepvp.com'),
    BlockedServer('75df09492c6c979e2db41116100093bb791b8433', '*.timelesspvp.net'),
    BlockedServer('d42339c120bc10a393a0b1d2c6a2e0ed4dbdd61b', '*.herowars.org'),
    BlockedServer('4a1b3b860ba0b441fa722bbcba97a614f6af9bb8', 'justgiveinandblockddnsbitches.ddns.net'),
    BlockedServer('b8c876f599dcf5162911bba2d543ccbd23d18ae5', 'brandonisagainst.health-carereform.com'),
    BlockedServer('9a9ae8e9d0b6f3bf54c266dcd1e4ec034e13f714', 'brandonwatchesporn.onthewifi.com'),
    BlockedServer('336e718ffbc705e76b4a72884172c6b95216b57c', 'canyouwildcardipsplease.gotdns.ch'),
    BlockedServer('27cf97ecf24c92f1fe5c84c5ff654728c3ee37dd', 'letsplaysome.servecounterstrike.com'),
    BlockedServer('32066aa0c7dc9b097eed5b00c5629ad03f250a2d', 'mojangbrokeintomy.homesecuritymac.com'),
    BlockedServer('39f4bbfd123a5a5ddbf97489877831c15a70d7f2', '*.primemc.org'),
    BlockedServer('f32f824d41aaed334aef248fbe3a0f8ecf4ac1a0', '*.meep.in'),
    BlockedServer('c22efe4cf7fb319ca2387bbc930c1fdf77ab72fc', '*.itsjerryandharry.com'),
    BlockedServer('cc8e1ae93571d144bf4b37369cb8466093d6db5a', '*.thearchon.net'),
    BlockedServer('9c0806e5ffaccb45121e57e4ce88c7bc76e057f1', '*.goatpvp.com'),
    BlockedServer('5ca81746337088b7617c851a1376e4f00d921d9e', '*.gotpvp.com'),
    BlockedServer('a5944b9707fdb2cc95ed4ef188cf5f3151ac0525', '*.guildcraft.org'),
  ];
}
