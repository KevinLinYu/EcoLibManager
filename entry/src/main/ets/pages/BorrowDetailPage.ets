import { router } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';

class Tmp {
  id: string = "";
  all: Array<relationalStore.ValuesBucket> = [];
}
const params = router.getParams() as Tmp;
const specificId = params.id;
const borrowRecords: Array<relationalStore.ValuesBucket> = params.all;

// 根据传入的ID筛选出需要的借阅信息
const borrowData: relationalStore.ValuesBucket | undefined = borrowRecords.find(record => record.id === specificId);

@Entry
@Component
struct BorrowDetailPage {
  @State borrowData: relationalStore.ValuesBucket = borrowData || {
    id: '',
    recordId: '',
    studentId: '',
    studentName: '',
    bookId: '',
    borrowDate: '',
    returnDate: ''
  }

  build() {
    Column() {
      Text("借阅详情")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })
        .textAlign(TextAlign.Center)

      Column() {
        Row() {
          Text("记录 ID：")
            .width('30%')
            .fontSize("20vp")
            .fontWeight(FontWeight.Medium)

          Text(this.borrowData.recordId?.toString() || '')
            .width('70%')
            .fontSize("20vp")
            .backgroundColor("#F9FAFB")
            .padding({ left: 8, right: 8 })
            .borderRadius(8)
        }
        .margin({ bottom: 12 })

        Row() {
          Text("学生 ID：")
            .width('30%')
            .fontSize("20vp")
            .fontWeight(FontWeight.Medium)

          Text(this.borrowData.studentId?.toString() || '')
            .width('70%')
            .fontSize("20vp")
            .backgroundColor("#F9FAFB")
            .padding({ left: 8, right: 8 })
            .borderRadius(8)
        }
        .margin({ bottom: 12 })

        Row() {
          Text("学生姓名：")
            .width('30%')
            .fontSize("20vp")
            .fontWeight(FontWeight.Medium)

          Text(this.borrowData.studentName?.toString() || '')
            .width('70%')
            .fontSize("20vp")
            .backgroundColor("#F9FAFB")
            .padding({ left: 8, right: 8 })
            .borderRadius(8)
        }
        .margin({ bottom: 12 })

        Row() {
          Text("书籍 ID：")
            .width('30%')
            .fontSize("20vp")
            .fontWeight(FontWeight.Medium)

          Text(this.borrowData.bookId?.toString() || '')
            .width('70%')
            .fontSize("20vp")
            .backgroundColor("#F9FAFB")
            .padding({ left: 8, right: 8 })
            .borderRadius(8)
        }
        .margin({ bottom: 12 })

        Row() {
          Text("借阅日期：")
            .width('30%')
            .fontSize("20vp")
            .fontWeight(FontWeight.Medium)

          Text(this.borrowData.borrowDate?.toString() || '')
            .width('70%')
            .fontSize("20vp")
            .backgroundColor("#F9FAFB")
            .padding({ left: 8, right: 8 })
            .borderRadius(8)
        }
        .margin({ bottom: 12 })

        Row() {
          Text("归还日期：")
            .width('30%')
            .fontSize("20vp")
            .fontWeight(FontWeight.Medium)

          Text(this.borrowData.returnDate?.toString() || '')
            .width('70%')
            .fontSize("20vp")
            .backgroundColor("#F9FAFB")
            .padding({ left: 8, right: 8 })
            .borderRadius(8)
        }
        .margin({ bottom: 12 })
      }
      .width('100%')
      .padding({ left: 12, right: 12, top: 16, bottom: 16 })
      .margin({ top: 20 })
    }
    .alignItems(HorizontalAlign.Center)
    .padding({ top: 20 })
    .backgroundColor("#F1F3F5")
    .height("100%")
  }
}
