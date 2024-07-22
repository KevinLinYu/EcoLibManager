import { router } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

class Tmp {
  all: Array<relationalStore.ValuesBucket> = []
}

const params = router.getParams() as Tmp
const booksArray: Array<relationalStore.ValuesBucket> = params.all
console.info(`Books array: ${JSON.stringify(booksArray)}`)

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'RdbLibMng.db',
  securityLevel: relationalStore.SecurityLevel.S1,
  customDir: 'customDir/subCustomDir'
};

@Entry
@Component
struct AddBookPage {
  @State title: string = ''
  @State author: string = ''
  @State isbn: string = ''
  @State quantity: number = 0
  @State description: string = ''
  @State location: string = ''

  saveBook() {
    let context = getContext(this)
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`)
        return
      }
      console.info('Succeeded in getting RdbStore.')

      const newBook: relationalStore.ValuesBucket = {
        TITLE: this.title,
        AUTHOR: this.author,
        ISBN: this.isbn,
        QUANTITY: this.quantity,
        DESCRIPTION: this.description,
        LOCATION: this.location
      }

      store.insert('BOOKS', newBook, (err: BusinessError, rowId: number) => {
        if (err) {
          console.error(`Failed to insert data. Code: ${err.code}, message: ${err.message}`)
          AlertDialog.show({
            message: `保存失败: ${err.message}`,
            confirm: {
              value: '关闭',
              action: () => {
              }
            }
          })
          return
        }
        console.info(`Succeeded in inserting data. rowId: ${rowId}`)
        AlertDialog.show({
          message: "保存成功",
          confirm: {
            value: '确定',
            action: () => {
              router.replaceUrl({ url: 'pages/MainPage' })
            }
          }
        })
      })
    })
  }

  build() {
    Column() {
      Column() {
        Text("添加图书")
          .fontSize("24fp")
          .fontWeight(FontWeight.Medium)
          .fontColor("#182431")
          .margin({ top: 20 })
      }
      .justifyContent(FlexAlign.Center)
      .height("30%")

      Column() {
        Row() {
          Text("标题：")
          TextInput({ placeholder: '请输入标题（不能为空）', text: this.title })
            .onChange((value: string) => {
              this.title = value
            })
            .inputStyle()
        }

        Row() {
          Text("作者：")
          TextInput({ placeholder: '请输入作者（不能为空）', text: this.author })
            .onChange((value: string) => {
              this.author = value
            })
            .inputStyle()
        }

        Row() {
          Text("书号：")
          TextInput({ placeholder: '请输入标准书号ISBN（唯一）', text: this.isbn })
            .onChange((value: string) => {
              this.isbn = value
            })
            .inputStyle()
        }

        Row() {
          Text("数量：")
          TextInput({ placeholder: '请输入数量', text: this.quantity.toString() })
            .onChange((value: string) => {
              this.quantity = parseInt(value)
            })
            .inputStyle()
        }

        Row() {
          Text("提要：")
          TextInput({ placeholder: '请输入内容提要', text: this.description })
            .onChange((value: string) => {
              this.description = value
            })
            .inputStyle()
        }

        Row() {
          Text("位置：")
          TextInput({ placeholder: '请输入架排位置', text: this.location })
            .onChange((value: string) => {
              this.location = value
            })
            .inputStyle()
        }
      }
      .width('100%')
      .padding({
        left: "12vp",
        right: "12vp"
      })

      Button("保存")
        .width("35%")
        .height("40vp")
        .fontSize("16vp")
        .fontWeight(FontWeight.Medium)
        .margin({
          top: "68vp",
          bottom: "12vp"
        })
        .onClick(() => {
          if (this.title === '' || this.author === '') {
            AlertDialog.show({
              message: "标题和作者不能为空！",
              confirm: {
                value: '关闭',
                action: () => {
                }
              }
            });
          } else if (booksArray.some(book => book.isbn === this.isbn)) {
            AlertDialog.show({
              message: "ISBN已存在或为空，请输入唯一的ISBN！",
              confirm: {
                value: '确定',
                action: () => {
                }
              }
            });
          } else {
            this.saveBook();
          }
        })
    }
    .backgroundColor("#F1F3F5")
    .height("100%")
  }
}

@Extend(TextInput)
function inputStyle() {
  .showUnderline(true)
  .underlineColor(Color.Gray)
  .width("72%")
  .alignSelf(ItemAlign.End);
}
