enum MiningPool { ethermine, rvnFlypool, flexpool }

final miningPoolPrettyNames = {
  MiningPool.ethermine: 'Ethermine',
  MiningPool.rvnFlypool: 'RavenCoin Flypool',
  MiningPool.flexpool: 'Flexpool'
};

bool validateMiningPoolAddress(MiningPool pool, String address) {
  switch (pool) {
    case MiningPool.ethermine:
    case MiningPool.flexpool:
      RegExp exp = RegExp(r"^\dx\w{40}$", caseSensitive: true);
      return exp.hasMatch(address);
    case MiningPool.rvnFlypool:
      RegExp exp = RegExp(r"^\w{34}$", caseSensitive: true);
      return exp.hasMatch(address);
    default:
      return false;
  }
}
