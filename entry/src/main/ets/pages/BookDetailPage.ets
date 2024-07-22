import { router } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

class Tmp {
  id: string = "";
  all: Array<relationalStore.ValuesBucket> = [];
}

// 从路由器获取参数并将其分配给变量
const params = router.getParams() as Tmp;
const specificId = params.id;
const booksArray: Array<relationalStore.ValuesBucket> = params.all;

console.log(`SPECIFICID是 ${specificId}`);
console.info(`图书数组：${JSON.stringify(booksArray)}`);

// 查找与特定ID匹配的图书数据
const bookData: relationalStore.ValuesBucket | undefined = booksArray.find(book => book.id === specificId);

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'RdbLibMng.db',
  securityLevel: relationalStore.SecurityLevel.S1,
  customDir: 'customDir/subCustomDir'
};

@Entry
@Component
struct BookDetailPage {
  @State bookData: relationalStore.ValuesBucket = bookData || {
    id: '',
    title: '',
    author: '',
    isbn: '',
    quantity: '',
    description: '',
    location: ''
  }

  // 保存图书数据的方法
  saveBook() {
    let context = getContext(this);
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`获取RdbStore失败。代码：${err.code}，消息：${err.message}`);
        return;
      }
      console.info('成功获取RdbStore。');

      const updatedBook: relationalStore.ValuesBucket = {
        TITLE: this.bookData.title,
        AUTHOR: this.bookData.author,
        ISBN: this.bookData.isbn,
        QUANTITY: this.bookData.quantity,
        DESCRIPTION: this.bookData.description,
        LOCATION: this.bookData.location
      };

      const predicates = new relationalStore.RdbPredicates('BOOKS');
      predicates.equalTo('ID', this.bookData.id);

      store.update(updatedBook, predicates, (err: BusinessError, rows: number) => {
        if (err) {
          console.error(`更新数据失败。代码：${err.code}，消息：${err.message}`);
          AlertDialog.show({
            message: `修改失败：${err.message}`,
            confirm: {
              value: '关闭',
              action: () => {
              }
            }
          });
          return;
        }
        console.info(`成功更新数据。行数：${rows}`);
        AlertDialog.show({
          message: "修改成功",
          confirm: {
            value: '确定',
            action: () => {
              router.replaceUrl({ url: 'pages/MainPage' });
            }
          }
        });
      });
    });
  }

  // 删除图书数据的方法
  deleteBook() {
    let context = getContext(this);
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`获取RdbStore失败。代码：${err.code}，消息：${err.message}`);
        return;
      }
      console.info('成功获取RdbStore。');

      const predicates = new relationalStore.RdbPredicates('BOOKS');
      predicates.equalTo('ID', this.bookData.id);

      store.delete(predicates, (err: BusinessError, rows: number) => {
        if (err) {
          AlertDialog.show({
            message: `删除失败：${err.message}`,
            confirm: {
              value: '关闭',
              action: () => {
              }
            }
          });
          return;
        }
        console.info(`成功删除数据。行数：${rows}`);
        AlertDialog.show({
          message: "删除成功",
          confirm: {
            value: '确定',
            action: () => {
              router.replaceUrl({ url: 'pages/MainPage' });
            }
          }
        });
      });
    });
  }

  build() {
    Column() {
      Column() {
        Text("图书详情 / 编辑")
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
          TextInput({ placeholder: '请输入标题（不能为空）', text: this.bookData.title?.toString() })
            .onChange((value: string) => {
              this.bookData.title = value;
            })
            .inputStyle()
        }

        Row() {
          Text("作者：")
          TextInput({ placeholder: '请输入作者（不能为空）', text: this.bookData.author?.toString() })
            .onChange((value: string) => {
              this.bookData.author = value;
            })
            .inputStyle()
        }

        Row() {
          Text("书号：")
          TextInput({ placeholder: '请输入标准书号ISBN（唯一）', text: this.bookData.isbn?.toString() })
            .onChange((value: string) => {
              this.bookData.isbn = value;
            })
            .inputStyle()
        }

        Row() {
          Text("数量：")
          TextInput({ placeholder: '请输入数量', text: this.bookData.quantity?.toString() })
            .onChange((value: string) => {
              this.bookData.quantity = parseInt(value);
            })
            .inputStyle()
        }

        Row() {
          Text("提要：")
          TextInput({ placeholder: '请输入内容提要', text: this.bookData.description?.toString() })
            .onChange((value: string) => {
              this.bookData.description = value;
            })
            .inputStyle()
        }

        Row() {
          Text("位置：")
          TextInput({ placeholder: '请输入架排位置', text: this.bookData.location?.toString() })
            .onChange((value: string) => {
              this.bookData.location = value;
            })
            .inputStyle()
        }
      }
      .width('100%')
      .padding({
        left: "12vp",
        right: "12vp"
      })

      Button("修改")
        .width("35%")
        .height("40vp")
        .fontSize("16vp")
        .fontWeight(FontWeight.Medium)
        .margin({
          top: "68vp",
          bottom: "12vp"
        })
        .onClick(() => {
          this.saveBook();
        })

      Button("删除图书")
        .width("35%")
        .height("40vp")
        .fontSize("16vp")
        .fontWeight(FontWeight.Medium)
        .backgroundColor("#FF4242")
        .margin({
          top: "8vp",
          bottom: "12vp"
        })
        .onClick(() => {
          AlertDialog.show({
            title: "警告",
            message: "您正在删除图书。确定删除此图书吗？",
            buttons: [{
              value: '确认',
              action: () => {
                this.deleteBook();
              }
            },
              {
                value: '取消',
                action: () => {
                }
              }]
          })
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
