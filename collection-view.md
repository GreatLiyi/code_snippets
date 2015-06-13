## UICollectionViewFlowLayout
automatically treat collectionView's delegate as self's delegate
The job of a layout object is to determine the placement of cells, supplementary views, and decoration views inside the collection view's bounds and to report that info to the collection view when asked.

### collection view's visual elements that need to be laid out:
- Cells: content
- Supplementary views: header and footer, cannot be selected
- Decoration views: visual adornments not tied to the data of the collection view, like supplementary view

### UICollectionViewScrollDirection
- Vertical
- Horizontal

### section kind (NSString *)
UICollectionElementKindSectionHeader
UICollectionElementKindSectionFooter

### supplementary view
- headerReferenceSize
- footerReferenceSize

### item spacing
- minimumLineSpacing //row spacing for vertical scroll, column spacing for Horizontal scroll
- minmumInteritemSpacing //item spacing
- itemSize
- estimatedItemSize //specify an estimate value lets the colleciton view defer calculations needed to determine the actual size of its content.
- sectionInset //margins used to layout content in a section
### scroll direction
- scrollDirection //vertical or Horizontal

-----------
## collection view
### switch view layout
- setCollectionViewLayout:animated:completion:

### 刷新collection view layout
- invalidateLayout: //整个collection view重新布局
- invalidateLayoutWithContext: //仅对某个区域context做重新布局，效率更高。需要用到UICollectionViewLayoutInvalidationContext class。
以下三种情况，当请求invalidate layout context时，collection view会做自动full layout update(@property invalidateEverything)
+ change current layout
+ change the data source of the collection view
+ call `reloadData` method

### UICollectionViewLayoutAttributes
