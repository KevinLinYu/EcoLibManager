import { router } from '@kit.ArkUI'
import { AccountData } from '../model/AccountData'
import { AccountModel } from '../model/AccountModel'

class SelectedValue {
  select: number = 2

  set(val: number) {
    this.select = val
  }
}

class SelectedArray {
  select: number[] = []

  set(val: number[]) {
    this.select = val
  }
}

@Entry
@Component
struct RegisterPage {
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
          RegisterTitle()
          RegisterBottom()
        }
      }
    }
    .backgroundColor("#F1F3F5")
  }
}

@Preview
@Component
struct RegisterTitle {
  build() {
    Column() {
      Image($r('app.media.app_icon')).width(80)
      Text("管理员注册")
        .fontSize("24fp")
        .fontWeight(FontWeight.Medium)
        .fontColor("#182431")
        .margin({ top: 20 })
    }
    .backgroundColor("#F1F3F5")
    .justifyContent(FlexAlign.Center)
    .width("100%")
    .height("30%")
  }
}

@Preview
@Component
struct RegisterBottom {
  @State name: string = ''
  @State phone_number: string = ''
  @State password: string = ''
  @State grade: string = ''
  @State male: boolean = true
  private grades: string[] = ['大学一年级', '大学二年级', '大学三年级', '大学四年级']
  private select: number = 0
  private bundleName: string = "com.gdust.ecolibmanager"
  private storage: AccountData = new AccountData()
  private accountModel: AccountModel = new AccountModel()

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

        TextInput({ placeholder: "电话号码" })
          .maxLength(11)
          .type(InputType.PhoneNumber)
          .inputStyle()
          .onChange((value: string) => {
            this.phone_number = value
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

        Line()
          .width("100%")
          .height("0.5vp")
          .margin({
            left: "12vp",
            right: "12vp"
          })
          .backgroundColor("#0D182431")

        Stack({ alignContent: Alignment.End }) {
          TextInput({ placeholder: "年级", text: this.grade })
            .id("grade text")
            .maxLength(11)
            .type(InputType.Normal)
            .inputStyle()
            .onChange((value: string) => {
              this.grade = value
            })
          Button("请选择年级")
            .onClick(() => {
              this.getUIContext().showTextPickerDialog({
                canLoop: false,
                range: this.grades,
                selected: this.select,
                onAccept: (value: TextPickerResult) => {
                  // 设置select为按下确定按钮时候的选中项index，这样当弹窗再次弹出时显示选中的是上一次确定的选项
                  let selectedVal = new SelectedValue()
                  let selectedArr = new SelectedArray()
                  if (value.index) {
                    value.index instanceof Array ? selectedArr.set(value.index) : selectedVal.set(value.index)
                  }
                  console.info("TextPickerDialog:onAccept()" + JSON.stringify(value))
                  this.grade = value.value as string
                },
                onCancel: () => {
                  console.info("TextPickerDialog:onCancel()")
                },
                onChange: (value: TextPickerResult) => {
                  console.info("TextPickerDialog:onChange()" + JSON.stringify(value))
                }
              })
            })
            .height("30vp")
            .margin({ right: "10vp" })
        }

        Line()
          .width("100%")
          .height("0.5vp")
          .margin({
            left: "12vp",
            right: "12vp"
          })
          .backgroundColor("#0D182431")

        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
          Text("性别：").fontColor("#99182431")
          Row() {
            Text("男")
            Radio({
              value: 'Radio1', group: 'radioGroup',
              indicatorType: RadioIndicatorType.TICK
            }).checked(true)
              .height(20)
              .width(20)
          }

          Row() {
            Text("女")
            Radio({
              value: 'Radio2', group: 'radioGroup',
              indicatorType: RadioIndicatorType.TICK
            }).checked(false)
              .height(20)
              .width(20)
              .onChange((isChecked: boolean) => {
                this.male = !isChecked
              })
          }
        }
        .height("48vp")

      }
      .backgroundColor(Color.White)
      .borderRadius("24vp")

      Button("注册")
        .width("100%")
        .height("40vp")
        .fontSize("16vp")
        .fontWeight(FontWeight.Medium)
        .margin({
          top: "68vp",
          bottom: "12vp"
        })
        .onClick(async () => {
          let res: RegExp = new RegExp(`^(大学(一|二|三|四)年级)$`)
          let result: boolean = await this.storage.hasStorageValue(getContext(), this.name, this.bundleName)
          if (this.name === '') {
            AlertDialog.show(
              {
                message: "姓名为空！",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else if (result) {
            AlertDialog.show(
              {
                message: "姓名已存在！",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else if (this.phone_number === '') {
            AlertDialog.show(
              {
                message: "电话号码为空！",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else if (this.password === '') {
            AlertDialog.show(
              {
                message: "密码为空！",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else if (this.password !== '' && this.password.length < 6) {
            AlertDialog.show(
              {
                message: "密码小于六位字符！",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else if (this.grade === '') {
            AlertDialog.show(
              {
                message: "年级为空！",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else if (this.grade !== '' && !res.test(this.grade)) {
            AlertDialog.show(
              {
                message: "年级格式错误！请使用按钮选择年级。",
                confirm: {
                  value: "关闭",
                  action: () => {
                  }
                }
              })
          } else {
            if (this.name !== '') {
              await this.accountModel.addAccount(`${this.name}`)
            }
            if (this.phone_number !== '') {
              await this.accountModel.setAccountCredential(`${this.name}`, `phone_number`, this.phone_number)
            }
            if (this.grade !== '') {
              await this.accountModel.setAccountCredential(`${this.name}`, `grade`, this.grade)
            }
            if (this.male) {
              await this.accountModel.setAccountCredential(`${this.name}`, `gender`, '男')
            } else {
              await this.accountModel.setAccountCredential(`${this.name}`, `gender`, '女')
            }
            await this.accountModel.setAssociatedData(`${this.name}`, `key`, this.password)
            await this.storage.putStorageValue(getContext(), this.name, this.password, this.bundleName)
            await this.storage.putStorageValue(getContext(), this.bundleName, 'true',
              `${this.name}`)
            AlertDialog.show(
              {
                title: "注册成功",
                message: "前往登录页面进行登录",
                confirm: {
                  value: "关闭",
                  action: () => {
                    router.replaceUrl({
                      url: 'pages/LoginPage',
                      params: {
                        bundleName: this.bundleName
                      }
                    })
                  }
                }
              })
          }
        })
    }
    .padding({
      left: "12vp",
      right: "12vp",
    })
    .backgroundColor("#F1F3F5")
    .height("70%")
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