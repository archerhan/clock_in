class IconAssetModel {
  String assetPath;
  bool isSelected;
  IconAssetModel(this.assetPath, this.isSelected);
}

enum IconCategory {
  business,
  entertainment,
  family,
  food,
  income,
  medical,
  shopping,
  skill,
  sport,
  traffic,
  others,
}

class IconCategoryModel {
  IconCategory category;
  List<IconAssetModel> iconAssets;
  IconCategoryModel(this.category, this.iconAssets);
  // fromJson
  factory IconCategoryModel.fromJson(Map<String, dynamic> json) {
    late IconCategory category;
    if (json['category'] == 'business') {
      category = IconCategory.business;
    } else if (json['category'] == 'entertainment') {
      category = IconCategory.entertainment;
    } else if (json['category'] == 'family') {
      category = IconCategory.family;
    } else if (json['category'] == 'food') {
      category = IconCategory.food;
    } else if (json['category'] == 'income') {
      category = IconCategory.income;
    } else if (json['category'] == 'medical') {
      category = IconCategory.medical;
    } else if (json['category'] == 'shopping') {
      category = IconCategory.shopping;
    } else if (json['category'] == 'skill') {
      category = IconCategory.skill;
    } else if (json['category'] == 'sport') {
      category = IconCategory.sport;
    } else if (json['category'] == 'traffic') {
      category = IconCategory.traffic;
    } else if (json['category'] == 'others') {
      category = IconCategory.others;
    }

    final icons = json['icons'] as List;
    var iconAssets = <IconAssetModel>[];
    for (var element in icons) {
      var model = IconAssetModel(element, false);
      iconAssets.add(model);
    }

    return IconCategoryModel(
      category,
      iconAssets,
    );
  }
}
