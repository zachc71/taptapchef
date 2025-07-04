import 'dart:math';

enum StaffType {
  tacoFlipper,
  flyerHandout,
  waitressOnSkates,
  grumpyCook,
  shiftManager,
  marketingIntern,
  corporateConsultant,
  brandAmbassador,
  alienSousChef,
  robotServer,
  aiHost,
  quantumCook,
  chronoChef,
  timeWaiter,
  multiverseManager,
  realityServer,
}

class Staff {
  final String name;
  final int baseCost;
  final double tapsPerSecond;

  const Staff(
      {required this.name, required this.baseCost, required this.tapsPerSecond});

  int costFor(int owned) => (baseCost * pow(1.15, owned)).ceil();
}

// Individual staff definitions so they can be reused across tier maps.
const Staff _tacoFlipper =
    Staff(name: 'Taco Flipper', baseCost: 250, tapsPerSecond: 0.6);
const Staff _flyerHandout =
    Staff(name: 'Flyer Handout Person', baseCost: 375, tapsPerSecond: 0.2);
const Staff _waitressOnSkates =
    Staff(name: 'Waitress on Skates', baseCost: 2000, tapsPerSecond: 3.0);
const Staff _grumpyCook =
    Staff(name: 'Grumpy but Efficient Cook', baseCost: 4000, tapsPerSecond: 6.0);
const Staff _shiftManager =
    Staff(name: 'Shift Manager', baseCost: 10000, tapsPerSecond: 10.0);
const Staff _marketingIntern =
    Staff(name: 'Marketing Intern', baseCost: 17500, tapsPerSecond: 2.0);
const Staff _corporateConsultant =
    Staff(name: 'Corporate Consultant', baseCost: 25000, tapsPerSecond: 12.0);
const Staff _brandAmbassador =
    Staff(name: 'Brand Ambassador', baseCost: 37500, tapsPerSecond: 16.0);
const Staff _alienSousChef =
    Staff(name: 'Alien Sous Chef', baseCost: 75000, tapsPerSecond: 24.0);
const Staff _robotServer =
    Staff(name: 'Robot Server', baseCost: 125000, tapsPerSecond: 30.0);
const Staff _aiHost =
    Staff(name: 'AI Host', baseCost: 200000, tapsPerSecond: 40.0);
const Staff _quantumCook =
    Staff(name: 'Quantum Cook', baseCost: 300000, tapsPerSecond: 50.0);
const Staff _chronoChef =
    Staff(name: 'Chrono Chef', baseCost: 500000, tapsPerSecond: 60.0);
const Staff _timeWaiter =
    Staff(name: 'Time Waiter', baseCost: 750000, tapsPerSecond: 70.0);
const Staff _multiverseManager =
    Staff(name: 'Multiverse Manager', baseCost: 1250000, tapsPerSecond: 90.0);
const Staff _realityServer =
    Staff(name: 'Reality Server', baseCost: 2000000, tapsPerSecond: 120.0);

/// Lookup for all staff by type regardless of tier.
const Map<StaffType, Staff> staffOptions = {
  StaffType.tacoFlipper: _tacoFlipper,
  StaffType.flyerHandout: _flyerHandout,
  StaffType.waitressOnSkates: _waitressOnSkates,
  StaffType.grumpyCook: _grumpyCook,
  StaffType.shiftManager: _shiftManager,
  StaffType.marketingIntern: _marketingIntern,
  StaffType.corporateConsultant: _corporateConsultant,
  StaffType.brandAmbassador: _brandAmbassador,
  StaffType.alienSousChef: _alienSousChef,
  StaffType.robotServer: _robotServer,
  StaffType.aiHost: _aiHost,
  StaffType.quantumCook: _quantumCook,
  StaffType.chronoChef: _chronoChef,
  StaffType.timeWaiter: _timeWaiter,
  StaffType.multiverseManager: _multiverseManager,
  StaffType.realityServer: _realityServer,
};

/// Staff available for each progression tier.
const Map<int, Map<StaffType, Staff>> staffByTier = {
  0: {
    StaffType.tacoFlipper: _tacoFlipper,
    StaffType.flyerHandout: _flyerHandout,
  },
  1: {
    StaffType.waitressOnSkates: _waitressOnSkates,
    StaffType.grumpyCook: _grumpyCook,
  },
  2: {
    StaffType.shiftManager: _shiftManager,
    StaffType.marketingIntern: _marketingIntern,
  },
  3: {
    StaffType.corporateConsultant: _corporateConsultant,
    StaffType.brandAmbassador: _brandAmbassador,
  },
  4: {
    StaffType.alienSousChef: _alienSousChef,
    StaffType.robotServer: _robotServer,
  },
  5: {
    StaffType.aiHost: _aiHost,
    StaffType.quantumCook: _quantumCook,
  },
  6: {
    StaffType.chronoChef: _chronoChef,
    StaffType.timeWaiter: _timeWaiter,
  },
  7: {
    StaffType.multiverseManager: _multiverseManager,
    StaffType.realityServer: _realityServer,
  },
  8: {
    StaffType.multiverseManager: _multiverseManager,
    StaffType.realityServer: _realityServer,
  },
  9: {
    StaffType.multiverseManager: _multiverseManager,
    StaffType.realityServer: _realityServer,
  },
 10: {
    StaffType.multiverseManager: _multiverseManager,
    StaffType.realityServer: _realityServer,
  },
};
