import { appAccount } from '@kit.BasicServicesKit';

// 创建appAccount的实例app，用于操作账户相关功能
const app: appAccount.AppAccountManager = appAccount.createAppAccountManager();

// 定义一个AccountModel类
export class AccountModel {
  async addAccount(username: string) {
    await app.createAccount(username);
    return;
  }

  // 删除账户的方法，参数为用户名
  async deleteAccount(username: string) {
    await app.removeAccount(username);
    return;
  }

  // 设置账户凭证的方法，参数为用户名、凭证类型和凭证值
  async setAccountCredential(username: string, credentialType: string, credential: string) {
    await app.setCredential(username, credentialType, credential);
    return;
  }

  // 设置关联数据的方法，参数为名称、键和值
  async setAssociatedData(name: string, key: string, value: string) {
    await app.setCustomData(name, key, value);
    return;
  }

  // 获取账户凭证的方法，参数为名称和凭证类型
  async getAccountCredential(name: string, credentialType: string) {
    let result = await app.getCredential(name, credentialType);
    return result;
  }

  // 获取关联数据的方法，参数为名称和键
  async getAssociatedData(name: string, key: string) {
    let result = await app.getCustomData(name, key);
    return result;
  }
}
