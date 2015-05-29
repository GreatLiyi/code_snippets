
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
