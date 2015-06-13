## 几种使用tableview cell的方法

### using cell objects in predefined styles
![predefined style cell](tv_cell_parts_simple.jpg)
需要注意的是image and text都是在cell content内部

### cells and tableview performance
- reuse cells. reuse cells instead of allocating new ones, you greatly enhance table view performance
- avoid relayout of content. Lay out the subviews once, when the cell is created.
- use opaque subviews. when customizing table view cells, make the subviews of the cell opaque, not transparent.
