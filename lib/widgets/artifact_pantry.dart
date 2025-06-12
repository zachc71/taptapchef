import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/artifact.dart';

class ArtifactPantry extends StatefulWidget {
  final GameState game;
  const ArtifactPantry({super.key, required this.game});

  @override
  State<ArtifactPantry> createState() => _ArtifactPantryState();
}

class _ArtifactPantryState extends State<ArtifactPantry> {
  Future<void> _selectArtifact(int slot) async {
    final available = widget.game.ownedArtifactIds
        .where((id) => !widget.game.equippedArtifactIds.contains(id))
        .toList();
    if (available.isEmpty) return;
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Equip Artifact'),
        children: [
          for (final id in available)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, id),
              child: Text(gameArtifacts[id]!.name),
            ),
        ],
      ),
    );
    if (selected != null) {
      setState(() {
        widget.game.equipArtifact(selected, slot);
      });
    }
  }

  void _showDetails(String id) {
    final art = gameArtifacts[id]!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(art.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(art.description),
            const SizedBox(height: 8),
            Text('Bonus: ${art.bonus.type.name} x${art.bonus.value}'),
            Text('Drawback: ${art.drawback.type.name} x${art.drawback.value}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final equipped = widget.game.equippedArtifactIds;
    final owned = widget.game.ownedArtifactIds;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Equipped', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (int i = 0; i < equipped.length; i++)
            _buildSlot(i, equipped[i]),
          const Divider(),
          Text('Owned Artifacts',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          for (final id in owned)
            ListTile(
              leading: Image.asset(
                gameArtifacts[id]!.iconAsset,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 40, height: 40),
              ),
              title: Text(gameArtifacts[id]!.name),
              onTap: () => _showDetails(id),
            ),
        ],
      ),
    );
  }

  Widget _buildSlot(int index, String? id) {
    if (id == null) {
      return ListTile(
        title: Text('Slot ${index + 1} - Empty'),
        trailing: ElevatedButton(
          onPressed: () => _selectArtifact(index),
          child: const Text('Equip'),
        ),
      );
    } else {
      final art = gameArtifacts[id]!;
      return ListTile(
        onTap: () => _showDetails(id),
        title: Text('Slot ${index + 1} - ${art.name}'),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              widget.game.unequipArtifact(index);
            });
          },
          child: const Text('Unequip'),
        ),
      );
    }
  }
}

