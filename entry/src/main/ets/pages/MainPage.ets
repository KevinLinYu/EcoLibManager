import BookManagementPage from '../SimNavDestination/BookManagementPage';
import BorrowManagementPage from '../SimNavDestination/BorrowManagementPage';

@Entry
@Component
struct MainPage {
  @State currentIndex: number = 0;

  build() {
    Tabs({
      barPosition: BarPosition.End,
      index: this.currentIndex
    }) {
      TabContent() {
        BookManagementPage()
      }
      .tabBar(this.TabBuilder("图书管理",
        0,
        $r("app.media.book_pages_fill_1_active"),
        $r("app.media.book_pages_fill_1")
      ))

      TabContent() {
        BorrowManagementPage()
      }
      .tabBar(this.TabBuilder("读者服务",
        1,
        $r("app.media.person_2_fill_active"),
        $r("app.media.person_2_fill")
      ))
    }
    .barWidth("100%")
    .barHeight("7.2%")
    .vertical(false)
    .backgroundColor(Color.White)
    .barMode(BarMode.Fixed)
    .scrollable(false)
    .onChange((index: number) => {
      this.currentIndex = index;
    })
  }

  @Builder
  TabBuilder(title: string, index: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? selectedImg : normalImg)
        .width("25vp")
        .height("25vp")
      Text(title)
        .margin({ top: "4vp" })
        .fontSize("10vp")
        .fontColor(this.currentIndex === index ? "#0959F7" : "#999999")
    }
    .justifyContent(FlexAlign.Center)
    .height("100%")
    .width("100%")
  }
}