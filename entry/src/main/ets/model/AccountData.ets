import { common } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';

// 定义存储变量storage和storageTemp
let storage: preferences.Preferences;
let storageTemp: preferences.Preferences;

export class AccountData {

  // 从存储中获取数据
  async getFromStorage(context: common.Context, url: string) {
    let name = url;
    try {
      storage = await preferences.getPreferences(context, `${name}`);
    } catch (err) {
      console.error(`getStorage failed, code is ${err?.code}, message is ${err?.message}`);
    }
  }

  // 获取存储数据
  async getStorage(context: common.Context, url: string) {
    storage = storageTemp;
    await this.getFromStorage(context, url);
    return storage;
  }

  // 存储键值对
  async putStorageValue(context: common.Context, key: string, value: string, url: string) {
    storage = await this.getStorage(context, url);
    try {
      await storage.put(key, value);
      await storage.flush();
    } catch (err) {}
    return;
  }

  // 判断存储中是否存在指定键值对
  async hasStorageValue(context: common.Context, key: string, url: string) {
    storage = await this.getStorage(context, url);
    let result: boolean = false;
    try {
      result = await storage.has(key);
    } catch (err) {
      console.error(`hasStorageValue failed, code is ${err?.code}, message is ${err?.message}`);
    }
    return result;
  }

  // 获取存储中指定键的值
  async getStorageValue(context: common.Context, key: string, url: string) {
    storage = await this.getStorage(context, url);
    let getValue: preferences.ValueType = 'null';
    try {
      getValue = await storage.get(key, 'null');
    } catch (err) {
      console.error(`getStorageValue failed, code is ${err?.code}, message is ${err?.message}`);
    }
    return getValue;
  }

  // 删除存储中指定键值对
  async deleteStorageValue(context: common.Context, key: string, url: string) {
    storage = await this.getStorage(context, url);
    try {
      await storage.delete(key);
      await storage.flush();
    } catch (err) {
      console.error(`deleteStorageValue failed, code is ${err?.code}, message is ${err?.message}`);
    }
    return;
  }
}