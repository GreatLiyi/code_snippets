
## scroll view performance

- transparency come at a price

## table view purposes
- presentation of information: each cell contains small, simplified info
- selection: select a cell
- navigation: usually master-detail interface

## tableview cell
- to set text and images of the cell, use the textLabel, detailTextLabel, and imageView properties
- go beyond the predefined styles, add subviews to the contentView property of the cell. When adding subviews, you are responsible for positioning those views and setting their content yourself.

### reusing cells
- initWithStyle:reuseIdentifier:
- dequeueReusableCellWithIdentifier:
- dequeueReusableCellWithIdentifier:atIndexPath:

### accessory type click event
when accessoryType=UITableViewCellAccessoryDetailDisclosureButton, the accessory view tracks touches, when tapped, sends the data-source object a tableView:accessoryButtonTappedForRowWithIndexPath: message.
- accessoryType
- editingAccessoryType
如果这两个属性未同时设置，cell切换时会有动画。以下两个属性类似：
- accessoryView
- editingAccessoryView

### cell selection and highlighting
highlight and selected
highlight happens on touch down
selected happens on touch up, followed by the call to didSelectRowAtIndexPath:
- textLabel.highlightedTextColor,detailTextLabel.highlightedTextColor
- imageView.highlightedImage

### editing the cell
editable state, displays the editing controls for it:
- green insertion control
- red deletion control
- reordering control
``` objective-c
typedef enum : NSInteger {
   UITableViewCellEditingStyleNone,
   UITableViewCellEditingStyleDelete,
   UITableViewCellEditingStyleInsert
} UITableViewCellEditingStyle;
```
//return editingStyle for row
tableView:editingStyleForRowAtIndexPath:

### reorder row
- showsReorderControl property
uitableViewDataSource method
- tableView:canMoveRowAtIndexPath:
- tableView:moveRowAtIndexPath:toIndexPath:

### table cell state transition
- willTransitionToState:
- didTransitionToState:

### table view properties about cells
- rowHeight
- separatorStyle,separatorColor,separatorInset
- backgroundColor, backgroundView
- tableHeaderView, tableFooterView

### table cell structure
- contentView(textLabel,detailTextLabel,custom view)
- accessoryView

### custom cell
几种方法
- subclass uitableviewcell
- addSubview in tableView:cellForRowAtIndexPath: method
- nib
- storyboard

### configure a cell
- tableView:cellForRowAtIndexPath:
- tableView:willDisplayCell:forRowAtIndexPath:  //last place to configure a cell

### section header and footer
class UITableViewHeaderFooterView
- use header or footer title string
tableView:titleForHeaderInSection:  //string apply to view's textLabel.text
tableView:titleForFooterInsection:
- use header or footer view
tableView:viewForHeaderInSection:
tableView:viewForFooterInSection:

### section index
- multi-sections
- implement data source method: tableView:titleForHeaderInSection:
- customize style of "section index title"
tableView.sectionIndexColor
sectionIndexBackgroundColor
sectionIndexTrackingBackgroundColor

### cell selection
uitableviewcell method
- setHighlighted:animated:
- setSelected:animated:
uitableview method
- @property allowSelection, allowMultipleSelection
- selectedBackgroundView property
- @property multipleSelectionBackgroundView
- indexPathForSelectedRow
- indexPathForSelectedRows
- selectRowAtIndexPath:animated:scrollPosition: (with nil as indexpath to deselect all)
- deselectRowAtIndexPath:animated:

### tableview scrolling and layout
indexpath和frame的相关转换
- indexPathForRowAtPoint:
- indexPathsForRowsInRect:
- rectForSelection:
- rectForRowAtIndexPath:
- rectForFooterInSection:
- rectForHeaderInSection:

### UISearchDisplayController(UISearchBar + UITableViewController)


## tableview editing
UIViewController setEditing:animation: 通常delegate到tableView setEditing:animation:方法
- tableView:canEditRowAtIndexPath: //data source
- tableView:editingStyleForRowAtIndexPath: //delegate 判断哪些row可以做Insert or Delete or None. 针对Insert，点击后直接触发tableView:commitEditingStyle:forRowAtIndexPath:方法；Delete点击后，右侧划出一个Delete按钮，确认后才触发commitEditingStyle方法。
- tableView:commitEditingStyle:forRowAtIndexPath:
通常做model update操作，之后更新tableView appearance。如果ui update有多条语句，可以包含在一个[tableView beginUpdates] and [tableView endUpdates]之间。具体的赋值操作不一定在这里处理，如果用到UITextField，那么textFieldDidEndEditing:(UITextField *)是一个合适的地方。

- insertRowsAtIndexPaths:withRowAnimation:
- deleteRowsAtIndexPaths:withRowAnimation:
- insertSections:withRowAnimation:
- deleteSections:withRowAnimation:
- moveSection:toSection:
- moveRowAtIndexPath:toIndexPath:
**you can combine them by surrounding with `beginUpdates` and `endUpdates`**

## rearranging table items
- tableView:moveRowAtIndexPath:toIndexPath: //if the data source implements this method, the table displays a reordering control in editing mode.
- tableView:canMoveRowAtIndexPath: //suppress individual row
- tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:  //limit destination row


## table view menus
