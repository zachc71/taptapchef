class FranchiseLocation {
  final String name;
  final String tierName;
  final String artAsset;

  const FranchiseLocation({
    required this.name,
    required this.tierName,
    required this.artAsset,
  });
}

const List<FranchiseLocation> franchiseProgression = [
  FranchiseLocation(name: 'Nashville', tierName: 'City', artAsset: 'assets/images/nashville.png'),
  FranchiseLocation(name: 'New York', tierName: 'City', artAsset: 'assets/images/new_york.png'),
  FranchiseLocation(name: 'Tokyo', tierName: 'City', artAsset: 'assets/images/tokyo.png'),

  FranchiseLocation(name: 'USA', tierName: 'Country', artAsset: 'assets/images/usa.png'),
  FranchiseLocation(name: 'Canada', tierName: 'Country', artAsset: 'assets/images/canada.png'),
  FranchiseLocation(name: 'Japan', tierName: 'Country', artAsset: 'assets/images/japan.png'),

  FranchiseLocation(name: 'Earth', tierName: 'Planet', artAsset: 'assets/images/earth.png'),
  FranchiseLocation(name: 'Mars', tierName: 'Planet', artAsset: 'assets/images/mars.png'),
];
