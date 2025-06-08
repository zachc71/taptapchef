enum StaffType { assistantChef, lineCook, robotChef, timeChef, dimensionManager }

class Staff {
  final String name;
  final int cost;
  final double tapsPerSecond;

  const Staff({required this.name, required this.cost, required this.tapsPerSecond});
}

const Map<StaffType, Staff> staffOptions = {
  StaffType.assistantChef: Staff(name: 'Assistant Chef', cost: 150, tapsPerSecond: 0.5),
  StaffType.lineCook: Staff(name: 'Line Cook', cost: 600, tapsPerSecond: 2.0),
  StaffType.robotChef: Staff(name: 'Robot Chef', cost: 3000, tapsPerSecond: 10.0),
  StaffType.timeChef:
      Staff(name: 'Time Traveler Chef', cost: 15000, tapsPerSecond: 50.0),
  StaffType.dimensionManager:
      Staff(name: 'Interdimensional Manager', cost: 60000, tapsPerSecond: 200.0),
};
