import '../../models/user.dart';
import '../../models/tier.dart';

class AccessControl {
  static bool canAccessRegion(User user, String requestedRegion) {
    if (user.tier == 'free') {
      return requestedRegion == 'global-demo';
    } else if (user.tier == 'developer') {
      return requestedRegion == 'sandbox';
    } else if (user.tier == 'organization') {
      return requestedRegion == user.tenantId || requestedRegion == 'clinic';
    } else if (user.tier == 'enterprise') {
      return true; // Enterprise can access all regions
    }
    return false;
  }

  static List<String> getAllowedFeatures(User user) {
    final config = tierConfigs[user.tier];
    return config?.features ?? [];
  }

  static bool hasFeature(User user, String feature) {
    final allowed = getAllowedFeatures(user);
    return allowed.contains('all') || allowed.contains(feature);
  }

  static String getSupportLevel(User user) {
    final config = tierConfigs[user.tier];
    return config?.supportLevel ?? 'none';
  }
}
