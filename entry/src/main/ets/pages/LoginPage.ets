import { router } from '@kit.ArkUI'
import { AccountData } from '../model/AccountData'
import { preferences } from '@kit.ArkData'

@Entry
@Component
struct LoginPage {
  build() {
    GridRow({
      columns: 4,
      gutter: 12
    }) {
      GridCol({
        span: 4,
        offset: 1
      }) {
        Column() {
          LoginTitle()
          LoginBottom()
        }
      }
    }
    .backgroundColor("#F1F3F5")
  }
}

@Preview
@Component
struct LoginTitle {
  build() {
    Column() {
      Image($r('app.media.app_icon')).width(80)
      Text("管理员登录")
        .fontSize("24fp")
        .fontWeight(FontWeight.Medium)
        .fontColor("#182431")
        .margin({ top: 20 })
    }
    .backgroundColor("#F1F3F5")
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height("40%")
  }
}

@Preview
@Component
struct LoginBottom {
  @State name: string = ''
  @State phone_number: string = ''
  @State password: string = ''
  @State grade: string = ''
  @State male: boolean = true
  private bundleName: string = "com.gdust.ecolibmanager"
  private storage: AccountData = new AccountData()

  build() {
    Column() {
      Column() {
        TextInput({ placeholder: "姓名" })
          .maxLength(11)
          .type(InputType.USER_NAME)
          .inputStyle()
          .onChange((value: string) => {
            this.name = value
          })

        Line()
          .width("100%")
          .height("0.5vp")
          .margin({
            left: "12vp",
            right: "12vp"
          })
          .backgroundColor("#0D182431")

        TextInput({ placeholder: "密码" })
          .maxLength(8)
          .type(InputType.NEW_PASSWORD)
          .inputStyle()
          .onChange((value: string) => {
            this.password = value
          })
      }
      .backgroundColor(Color.White)
      .borderRadius("24vp")


      Button("登录")
        .width("100%")
        .height("40vp")
        .fontSize("16vp")
        .fontWeight(FontWeight.Medium)
        .margin({
          top: "48vp"
        })
        .onClick(async () => {
          let result: boolean = await this.storage.hasStorageValue(getContext(), this.name, this.bundleName)
          let storedPassword: preferences.ValueType = await this.storage.getStorageValue(getContext(), this.name, this.bundleName)
          if (this.name === '') {
            AlertDialog.show(
              {
                message: "姓名为空！",
                confirm: {
                  value: "关闭",
                  action: () => {}
                }
              })
          } else if (this.password === '') {
            AlertDialog.show(
              {
                message: "密码为空！",
                confirm: {
                  value: "关闭",
                  action: () => {}
                }
              })
          } else if (this.password !== '' && this.password.length < 6) {
            AlertDialog.show(
              {
                message: "密码小于六位字符！",
                confirm: {
                  value: "关闭",
                  action: () => {}
                }
              })
          } else {
            if (this.password === storedPassword) {
              // 登录成功逻辑
              AlertDialog.show({
                message: "登录成功！",
                confirm: {
                  value: "关闭",
                  action: () => {
                    router.replaceUrl({
                      url: 'pages/MainPage',
                      params: {
                        bundleName: this.bundleName
                      }
                    })
                  }
                }
              })
            } else if (!result) {
              // 登录失败逻辑
              AlertDialog.show(
                {
                  title: "姓名错误",
                  message: "姓名不存在于数据库中。\n请重新检查您的信息或注册新帐号！",
                  confirm: {
                    value: "关闭",
                    action: () => {}
                  }
                })
            } else if (result) {
              AlertDialog.show(
                {
                  title: "密码错误",
                  message: "姓名存在于数据库中，但与密码不匹配。\n请重新检查您的信息！",
                  confirm: {
                    value: "关闭",
                    action: () => {}
                  }
                })
            } else {
              AlertDialog.show({
                message: "姓名或密码错误！",
                confirm: {
                  value: "关闭",
                  action: () => {}
                }
              })
            }
          }
        })
      Button("注册账号")
        .margin({
          top: "10vp"
        })
        .backgroundColor("#F1F3F5")
        .fontColor("#007DFF")
        .fontSize("16fp")
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/RegisterPage'
          })
        })
    }
    .padding({
      left: "12vp",
      right: "12vp",
    })
    .backgroundColor("#F1F3F5")
    .height("60%")
  }
}

@Extend(TextInput)
function inputStyle() {
  .height("48vp")
  .fontSize("16vp")
  .backgroundColor(Color.White)
  .margin({ top: "4vp" })
  .padding({ left: 12 })
}
