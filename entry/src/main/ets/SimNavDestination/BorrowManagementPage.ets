import { relationalStore } from '@kit.ArkData';
import { router } from '@kit.ArkUI';

const STORE_CONFIG: relationalStore.StoreConfig = {
  name: 'RdbLibMng.db',
  securityLevel: relationalStore.SecurityLevel.S1,
  encrypt: false,
  customDir: 'customDir/subCustomDir'
};

@Component
export default struct BorrowManagementPage {
  @State studentId: string = "";
  @State studentName: string = "";
  @State borrowRecords: Array<relationalStore.ValuesBucket> = [];
  @State borrowCount: number = 0;

  aboutToAppear() {
    this.loadBorrowRecords();
  }

  loadBorrowRecords() {
    let context = getContext(this);
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');

      let predicates = new relationalStore.RdbPredicates("BORROW_RECORDS");
      predicates.equalTo('STUDENT_ID', this.studentId);

      store.query(predicates, (err, resultSet) => {
        if (err) {
          console.error(`Query failed, code is ${err.code}, message is ${err.message}`);
          return;
        }

        let records: Array<relationalStore.ValuesBucket> = [];
        while (resultSet.goToNextRow()) {
          records.push({
            id: resultSet.getLong(resultSet.getColumnIndex("ID")),
            recordId: resultSet.getString(resultSet.getColumnIndex("RECORD_ID")),
            studentId: resultSet.getString(resultSet.getColumnIndex("STUDENT_ID")),
            studentName: resultSet.getString(resultSet.getColumnIndex("STUDENT_NAME")),
            bookId: resultSet.getString(resultSet.getColumnIndex("BOOK_ID")),
            borrowDate: resultSet.getString(resultSet.getColumnIndex("BORROW_DATE")),
            returnDate: resultSet.getString(resultSet.getColumnIndex("RETURN_DATE")),
          });
        }
        resultSet.close();
        this.borrowRecords = records;
        this.borrowCount = records.length;
        if (records.length > 0) {
          this.studentName = records[0].studentName as string;
        } else {
          this.studentName = "";
        }
        console.info(`Borrow records: ${JSON.stringify(this.borrowRecords)}`);

        if (this.studentName) {
          AlertDialog.show({
            message: `学生姓名：${this.studentName}（ID：${this.studentId}）\n共借阅了${this.borrowCount}次书籍`
          })
        }
      });
    });
  }

  build() {
    Column() {
      Text("读者服务（借阅管理）")
        .fontWeight(FontWeight.Medium)
        .fontSize("24vp")
        .margin("12vp")

      TextInput({ placeholder: '请输入学生ID', text: this.studentId })
        .width("72%")
        .onChange((value: string) => {
          this.studentId = value;
        })

      Button("查询借阅信息")
        .margin({ top: "14vp", bottom: "14vp" })
        .onClick(() => {
          this.loadBorrowRecords();
        })

      List({ space: 12, initialIndex: 0 }) {
        ForEach(this.borrowRecords, (record: relationalStore.ValuesBucket) => {
          ListItem() {
            Column() {
              Text("记录ID：" + record.recordId).textStyle()
              Text("学生ID：" + record.studentId).textStyle()
              Text("学生姓名：" + record.studentName).textStyle()
              Text("书籍ID：" + record.bookId).textStyle()
            }
            .padding(10)
            .margin({ bottom: 12, left: "5%" })
            .backgroundColor('#F0F0F0')
            .borderRadius(12)
          }.onClick(() => {
            router.pushUrl({
              url: 'pages/BorrowDetailPage',
              params: { id: record.id, all: this.borrowRecords }
            });
          })
        })
      }
      .margin({ bottom: "42.2%" })
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