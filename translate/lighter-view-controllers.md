在iOS项目中，view controllers通常是最大的文件，包含过多的代码。另外，view controller也是代码中最少能复用的。下面我们将关注一些使得view controller变瘦，代码可重用的技巧，同时将代码移动到合适的敌方。
这篇文章的[示例代码](https://github.com/objcio/issue-1-lighter-view-controllers)在github上。
## 分离数据源和其他协议
将UITableViewDataSource部分的代码分离并移到单独的类中，是为view controller瘦身的最强大的方法之一。如果做过多次，你将会总结出其中的模式，并创建可复用的类。

例如，在示例项目中，有一个PhotosViewController类，它有如下方法：
``` objective-c
# pragma mark Pragma

- (Photo*)photoAtIndexPath:(NSIndexPath*)indexPath {
    return photos[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return photos.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    PhotoCell* cell = [tableView dequeueReusableCellWithIdentifier:PhotoCellIdentifier
                                                      forIndexPath:indexPath];
    Photo* photo = [self photoAtIndexPath:indexPath];
    cell.label.text = photo.name;
    return cell;
}
```
上面代码大部分与数组有关，其中有些专门针对view controller管理的图片。我们先把数组相关的代码移到单独的类中。我们会用block来配置cell，根据你的用例和口味可可以用delegate。
``` objective-c
@implementation ArrayDataSource

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    configureCellBlock(cell,item);
    return cell;
}

@end
```
你可以创建一个ArrayDataSource实例，并设置为table View的数据源，这样之前view controller中的三个方法可以去掉了。

## 将域逻辑移动到model

## 创建Store类

## 将Web Service逻辑移到model层

## 将view代码移到view层

## 通讯

## 结论

### 扩展阅读
