## 在nib中如何初始化一个属性？
- 在awakeFromNib中初始化,call super
- 使用property lazy-init

> nib-loading
The nib-loading infrastructure sends an awakeFromNib message to each object recreated from a nib archive, but only after all the objects in the archive have been loaded and initialized. When an object receives an awakeFromNib message, it is guaranteed to have all its outlet and action connections already established
>
