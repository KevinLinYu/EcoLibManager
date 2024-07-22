import { relationalStore } from '@kit.ArkData';
import { router } from '@kit.ArkUI';

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'RdbLibMng.db',
  securityLevel: relationalStore.SecurityLevel.S1,
  encrypt: false,
  customDir: 'customDir/subCustomDir'
};

@Component
export default struct BookManagementPage {
  @State booksArray: Array<relationalStore.ValuesBucket> = [];

  aboutToAppear() {
    this.loadBooks();
  }

  loadBooks() {
    let context = getContext(this);
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');

      let predicates = new relationalStore.RdbPredicates("BOOKS");
      store.query(predicates, (err, resultSet) => {
        if (err) {
          console.error(`Query failed, code is ${err.code}, message is ${err.message}`);
          return;
        }

        let books: Array<relationalStore.ValuesBucket> = [];
        while (resultSet.goToNextRow()) {
          books.push({
            id: resultSet.getLong(resultSet.getColumnIndex("ID")),
            title: resultSet.getString(resultSet.getColumnIndex("TITLE")),
            author: resultSet.getString(resultSet.getColumnIndex("AUTHOR")),
            isbn: resultSet.getString(resultSet.getColumnIndex("ISBN")),
            quantity: resultSet.getLong(resultSet.getColumnIndex("QUANTITY")),
            description: resultSet.getString(resultSet.getColumnIndex("DESCRIPTION")),
            location: resultSet.getString(resultSet.getColumnIndex("LOCATION"))
          });
        }
        resultSet.close();
        this.booksArray = books;
        console.info(`Books array: ${JSON.stringify(this.booksArray)}`);
      });
    });
  }

  build() {
    Column() {
      Row() {
        Text("图书管理")
          .fontWeight(FontWeight.Medium)
          .fontSize("24vp")
          .margin("12vp")
          .alignSelf(ItemAlign.Start)

        Blank()

        Image($r("app.media.plus"))
          .width(26)
          .borderRadius("26vp")
          .align(Alignment.End)
          .margin("12vp")
          .onClick(() => {
            router.pushUrl({
              url: "pages/AddBookPage",
              params: {
                all: this.booksArray
              }
            });
          })
      }
      .width("100%")

      List({ space: 12, initialIndex: 0 }) {
        ForEach(this.booksArray, (book: relationalStore.ValuesBucket) => {
          ListItem() {
            Column() {
              Text("标题：" + book.title).textStyle()
              Text("作者：" + book.author).textStyle()
              Text("ISBN:  " + book.isbn).textStyle()

              Button("详情 / 编辑")
                .height("28vp")
                .fontSize("14vp")
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.End)
                .onClick(() => {
                  router.pushUrl({
                    url: "pages/BookDetailPage",
                    params: {
                      id: book.id,
                      all: this.booksArray
                    }
                  });
                })
            }
            .padding(10)
            .margin({ bottom: 12, left: "5%" })
            .backgroundColor('#F0F0F0')
            .borderRadius(12)
          }
          .onClick(() => {

          })
        })
      }
      .margin({ bottom: "12.2%" })

      Blank()
    }
  }
}

@Extend(Text)
function textStyle() {
  .width('90%')
  .height(30)
  .margin({ left: "2%" })
  .fontSize(14)
  .fontWeight(400)
  .textAlign(TextAlign.Start)
}
