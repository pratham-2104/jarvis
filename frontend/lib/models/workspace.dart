class Workspace {
  final String name;
  final Map<String, List<String>> folders;

  Workspace({
    required this.name,
    this.folders = const {},
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    Map<String, List<String>> foldersMap = {};
    
    // Iterate through all keys in the JSON
    json.forEach((key, value) {
      if (key == 'name') return; // Skip the name field

      // Handle the 'folders' map format if present
      if (key == 'folders' && value is Map<String, dynamic>) {
        value.forEach((fName, fFiles) {
          foldersMap[fName] = List<String>.from(fFiles);
        });
      } 
      // Handle flat lists like 'knowledgeFiles', 'buildFiles', 'brandFiles'
      else if (value is List) {
        // Clean up key name: 'knowledgeFiles' -> 'knowledge'
        String folderName = key.replaceAll('Files', '');
        // Only add if not already present from the 'folders' map
        if (!foldersMap.containsKey(folderName)) {
          foldersMap[folderName] = List<String>.from(value);
        }
      }
    });

    return Workspace(
      name: json['name'] ?? 'Unknown',
      folders: foldersMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'folders': folders,
    };
  }
}
