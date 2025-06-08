enum StaffType {
  tacoFlipper,
  flyerHandout,
  waitressOnSkates,
  grumpyCook,
  shiftManager,
  marketingIntern,
}

class Staff {
  final String name;
  final int cost;
  final double tapsPerSecond;

  const Staff(
      {required this.name, required this.cost, required this.tapsPerSecond});
}

// Individual staff definitions so they can be reused across tier maps.
const Staff _tacoFlipper =
    Staff(name: 'Taco Flipper', cost: 50, tapsPerSecond: 0.3);
const Staff _flyerHandout =
    Staff(name: 'Flyer Handout Person', cost: 75, tapsPerSecond: 0.1);
const Staff _waitressOnSkates =
    Staff(name: 'Waitress on Skates', cost: 400, tapsPerSecond: 1.5);
const Staff _grumpyCook =
    Staff(name: 'Grumpy but Efficient Cook', cost: 800, tapsPerSecond: 3.0);
const Staff _shiftManager =
    Staff(name: 'Shift Manager', cost: 2000, tapsPerSecond: 5.0);
const Staff _marketingIntern =
    Staff(name: 'Marketing Intern', cost: 3500, tapsPerSecond: 1.0);

/// Lookup for all staff by type regardless of tier.
const Map<StaffType, Staff> staffOptions = {
  StaffType.tacoFlipper: _tacoFlipper,
  StaffType.flyerHandout: _flyerHandout,
  StaffType.waitressOnSkates: _waitressOnSkates,
  StaffType.grumpyCook: _grumpyCook,
  StaffType.shiftManager: _shiftManager,
  StaffType.marketingIntern: _marketingIntern,
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
};
