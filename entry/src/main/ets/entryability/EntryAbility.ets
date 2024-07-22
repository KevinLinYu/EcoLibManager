import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/LoginPage', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });

    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'RdbLibMng.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      customDir: 'customDir/subCustomDir' // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
    };

    const SQL_CREATE_TABLE =
      'CREATE TABLE IF NOT EXISTS BOOKS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT NOT NULL, AUTHOR TEXT NOT NULL, ISBN TEXT UNIQUE, QUANTITY INTEGER, DESCRIPTION TEXT, LOCATION TEXT)';

    const SQL_CREATE_BORROW_TABLE =
      'CREATE TABLE IF NOT EXISTS BORROW_RECORDS (ID INTEGER PRIMARY KEY AUTOINCREMENT, RECORD_ID TEXT UNIQUE, STUDENT_ID INTEGER, STUDENT_NAME TEXT, BOOK_ID INTEGER, BORROW_DATE TEXT, RETURN_DATE TEXT)';

    relationalStore.getRdbStore(this.context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');

      if (store.version === 0) {
        store.executeSql(SQL_CREATE_TABLE); // 创建数据表
        store.executeSql(SQL_CREATE_BORROW_TABLE); // 创建借阅记录表
        store.version = 4;
      }

      const books: Array<relationalStore.ValuesBucket> = [
        {
          TITLE: '围城',
          AUTHOR: '钱锺书',
          ISBN: '978-7-02-007060-2',
          QUANTITY: 10,
          DESCRIPTION: '一部讽刺幽默的长篇小说，以幽默的笔调描绘了现代中国知识分子在爱情和婚姻上的困惑和悲剧',
          LOCATION: '书架B1'
        },
        {
          TITLE: '红楼梦',
          AUTHOR: '曹雪芹',
          ISBN: '978-7-02-007061-9',
          QUANTITY: 8,
          DESCRIPTION: '以贾宝玉、林黛玉、薛宝钗之间的爱情故事为主线，展现了大观园中众人的命运浮沉',
          LOCATION: '书架B2'
        },
        {
          TITLE: '三国演义',
          AUTHOR: '罗贯中',
          ISBN: '978-7-02-007062-6',
          QUANTITY: 7,
          DESCRIPTION: '以三国时期群雄争霸的历史为背景，塑造了众多英雄人物',
          LOCATION: '书架B3'
        },
        {
          TITLE: '水浒传',
          AUTHOR: '施耐庵',
          ISBN: '978-7-02-007063-3',
          QUANTITY: 6,
          DESCRIPTION: '讲述了一百零八将聚义梁山的故事，展现了北宋末年的社会风貌',
          LOCATION: '书架B4'
        },
        {
          TITLE: '西游记',
          AUTHOR: '吴承恩',
          ISBN: '978-7-02-007064-0',
          QUANTITY: 5,
          DESCRIPTION: '以唐僧西天取经的故事为主线，展现了孙悟空、猪八戒等神魔斗法的奇幻世界',
          LOCATION: '书架B5'
        },
        {
          TITLE: '平凡的世界',
          AUTHOR: '路遥',
          ISBN: '978-7-02-007065-7',
          QUANTITY: 4,
          DESCRIPTION: '一部现实主义长篇小说，讲述了中国北方农村两个普通青年在改革开放的大时代背景下，不断追求进步与奋斗的人生故事',
          LOCATION: '书架B6'
        },
        {
          TITLE: '活着',
          AUTHOR: '余华',
          ISBN: '978-7-02-007066-4',
          QUANTITY: 3,
          DESCRIPTION: '一部悲剧色彩浓厚的长篇小说，以福贵的坎坷人生为线索，展现了中国社会几十年的变迁与个体命运的起落',
          LOCATION: '书架B7'
        }
      ];
      books.forEach((book, index) => {
        (store as relationalStore.RdbStore).insert('BOOKS', book, (err: BusinessError, rowId: number) => {
          if (err) {
            console.error(`Failed to insert data for book ${index + 1}. Code: ${err.code}, message: ${err.message}`);
            return;
          }
          console.info(`Succeeded in inserting data for book ${index + 1}. rowId: ${rowId}`);
        });
      });

      const borrowRecords: Array<relationalStore.ValuesBucket> = [
        {
          RECORD_ID: "BR1",
          STUDENT_ID: 1001,
          STUDENT_NAME: "张华",
          BOOK_ID: 10,
          BORROW_DATE: "2024-01-01",
          RETURN_DATE: "2024-01-10"
        },
        {
          RECORD_ID: "BR2",
          STUDENT_ID: 1002,
          STUDENT_NAME: "李伟",
          BOOK_ID: 12,
          BORROW_DATE: "2024-01-02",
          RETURN_DATE: "2024-01-12"
        },
        {
          RECORD_ID: "BR3",
          STUDENT_ID: 1003,
          STUDENT_NAME: "王芳",
          BOOK_ID: 15,
          BORROW_DATE: "2024-01-05",
          RETURN_DATE: "2024-01-18"
        },
        {
          RECORD_ID: "BR4",
          STUDENT_ID: 1004,
          STUDENT_NAME: "刘洋",
          BOOK_ID: 18,
          BORROW_DATE: "2024-01-06",
          RETURN_DATE: "2024-01-20"
        },
        {
          RECORD_ID: "BR5",
          STUDENT_ID: 1001,
          STUDENT_NAME: "张华",
          BOOK_ID: 20,
          BORROW_DATE: "2024-01-10",
          RETURN_DATE: "2024-01-25"
        },
        {
          RECORD_ID: "BR6",
          STUDENT_ID: 1005,
          STUDENT_NAME: "陈强",
          BOOK_ID: 22,
          BORROW_DATE: "2024-01-11",
          RETURN_DATE: "2024-01-28"
        },
        {
          RECORD_ID: "BR7",
          STUDENT_ID: 1003,
          STUDENT_NAME: "王芳",
          BOOK_ID: 25,
          BORROW_DATE: "2024-01-15",
          RETURN_DATE: "2024-01-30"
        },
        {
          RECORD_ID: "BR8",
          STUDENT_ID: 1006,
          STUDENT_NAME: "张丽",
          BOOK_ID: 28,
          BORROW_DATE: "2024-01-18",
          RETURN_DATE: "2024-02-04"
        },
        {
          RECORD_ID: "BR9",
          STUDENT_ID: 1004,
          STUDENT_NAME: "刘洋",
          BOOK_ID: 30,
          BORROW_DATE: "2024-02-01",
          RETURN_DATE: "2024-02-14"
        },
        {
          RECORD_ID: "BR10",
          STUDENT_ID: 1002,
          STUDENT_NAME: "李伟",
          BOOK_ID: 33,
          BORROW_DATE: "2024-02-03",
          RETURN_DATE: "2024-02-17"
        },
        {
          RECORD_ID: "BR11",
          STUDENT_ID: 1004,
          STUDENT_NAME: "刘洋",
          BOOK_ID: 35,
          BORROW_DATE: "2024-02-05",
          RETURN_DATE: "2024-02-20"
        },
        {
          RECORD_ID: "BR12",
          STUDENT_ID: 1004,
          STUDENT_NAME: "刘洋",
          BOOK_ID: 38,
          BORROW_DATE: "2024-02-08",
          RETURN_DATE: "2024-02-26"
        },
        {
          RECORD_ID: "BR13",
          STUDENT_ID: 1008,
          STUDENT_NAME: "李晓莉",
          BOOK_ID: 40,
          BORROW_DATE: "2024-02-10",
          RETURN_DATE: "2024-03-03"
        },
        {
          RECORD_ID: "BR14",
          STUDENT_ID: 1004,
          STUDENT_NAME: "刘洋",
          BOOK_ID: 42,
          BORROW_DATE: "2024-02-12",
          RETURN_DATE: "2024-03-01"
        },
        {
          RECORD_ID: "BR15",
          STUDENT_ID: 1001,
          STUDENT_NAME: "张华",
          BOOK_ID: 45,
          BORROW_DATE: "2024-02-15",
          RETURN_DATE: "2024-03-06"
        }
      ];

      borrowRecords.forEach((record, index) => {
        (store as relationalStore.RdbStore).insert('BORROW_RECORDS', record, (err: BusinessError, rowId: number) => {
          if (err) {
            console.error(`Failed to insert borrow record ${index + 1}. Code: ${err.code}, message: ${err.message}`);
            return;
          }
          console.info(`Succeeded in inserting borrow record ${index + 1}. rowId: ${rowId}`);
        });
      });
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}