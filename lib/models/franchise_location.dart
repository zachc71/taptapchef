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

const List<String> franchiseTiers = ['City', 'Country', 'Planet'];

/// Groups of [FranchiseLocation] names that rotate each prestige.
const List<List<FranchiseLocation>> franchiseLocationSets = [
  [
    FranchiseLocation(
        name: 'Nashville', tierName: 'City', artAsset: 'assets/images/nashville.png'),
    FranchiseLocation(
        name: 'USA', tierName: 'Country', artAsset: 'assets/images/usa.png'),
    FranchiseLocation(
        name: 'Earth', tierName: 'Planet', artAsset: 'assets/images/earth.png'),
  ],
  [
    FranchiseLocation(
        name: 'New York', tierName: 'City', artAsset: 'assets/images/new_york.png'),
    FranchiseLocation(
        name: 'Canada', tierName: 'Country', artAsset: 'assets/images/canada.png'),
    FranchiseLocation(
        name: 'Mars', tierName: 'Planet', artAsset: 'assets/images/mars.png'),
  ],
  [
    FranchiseLocation(
        name: 'Tokyo', tierName: 'City', artAsset: 'assets/images/tokyo.png'),
    FranchiseLocation(
        name: 'Japan', tierName: 'Country', artAsset: 'assets/images/japan.png'),
    FranchiseLocation(
        name: 'Venus', tierName: 'Planet', artAsset: 'assets/images/venus.png'),
  ],
];
