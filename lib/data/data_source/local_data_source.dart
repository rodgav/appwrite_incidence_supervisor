import 'package:appwrite_incidence_supervisor/domain/model/name_model.dart';
import 'package:appwrite_incidence_supervisor/domain/model/user_model.dart';

const cachePrioritysKey = 'cachePrioritysKey';
const cacheTypeUsersKey = 'cacheTypeUsersKey';
const cacheUserKey = 'cacheUserKey';
const cacheInterval = 180 * 10000;

abstract class LocalDataSource {
  void clearCache();

  void removeFromCache(String key);

  void savePrioritysToCache(List<Name> names);

  List<Name> getPrioritys();

  void saveTypeUsersToCache(List<Name> names);

  List<Name> getTypeUsers();

  void saveUser(UsersModel user);
  UsersModel getUser();
}

class LocalDataSourceImpl implements LocalDataSource {
  Map<String, CachedItem> cacheMap = {};

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<void> savePrioritysToCache(List<Name> names) async {
    cacheMap[cachePrioritysKey] = CachedItem(names);
  }

  @override
  List<Name> getPrioritys() {
    CachedItem? cachedItem = cacheMap[cachePrioritysKey];
    if (cachedItem != null && cachedItem.isValid(cacheInterval)) {
      return cachedItem.data;
    } else {
      throw 'error cache prioritys';
    }
  }

  @override
  void saveTypeUsersToCache(List<Name> names) async {
    cacheMap[cacheTypeUsersKey] = CachedItem(names);
  }

  @override
  List<Name> getTypeUsers() {
    CachedItem? cachedItem = cacheMap[cacheTypeUsersKey];
    if (cachedItem != null && cachedItem.isValid(cacheInterval)) {
      return cachedItem.data as List<Name>;
    } else {
      throw 'error cache type Users';
    }
  }

  @override
  void saveUser(UsersModel user){
    cacheMap[cacheUserKey] = CachedItem(user);
  }

  @override
  UsersModel getUser() {
    CachedItem? cachedItem = cacheMap[cacheUserKey];
    if(cachedItem!=null){
      return cachedItem.data;
    }else{
      throw 'error cache user';
    }
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isValid(int expirationTime) {
    int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    bool isCacheValid = currentTimeInMillis - expirationTime < cacheTime;
    return isCacheValid;
  }
}
