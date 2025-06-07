enum StaffType { assistantChef, lineCook, robotChef }

class Staff {
  final String name;
  final int cost;
  final double tapsPerSecond;

  const Staff({required this.name, required this.cost, required this.tapsPerSecond});
}

const Map<StaffType, Staff> staffOptions = {
  StaffType.assistantChef: Staff(name: 'Assistant Chef', cost: 50, tapsPerSecond: 0.5),
  StaffType.lineCook: Staff(name: 'Line Cook', cost: 200, tapsPerSecond: 2.0),
  StaffType.robotChef: Staff(name: 'Robot Chef', cost: 1000, tapsPerSecond: 10.0),
};
