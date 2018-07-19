# XYXFlatSegmentControl

自定义的SegmentControl, 所有按钮通过titles属性自动添加, 均匀平铺在界面同一行上, 切记仅且只有有一行.
可自定义按钮颜色、字体大小、下划线厚度等.也可以自定义初始化时哪个按钮应该被选中.

![bbb](/bbb.gif)

# 支持Cocoapods
获取方法:
pod 'XYXFlatSegmentControl', '~> 1.2.4'
 

# 初始化: 支持xib, 也支持纯代码方式
```
let segmentControl = XYXFlatSegmentControl()
let segmentControl = XYXFlatSegmentControl(frame:<#frame#>)
```

接下来segmentControl所有的参数都是选填的,请根据需求设置(过于简单的不列出):
```
 segmentControl.titles 用于一次性设置所有按钮的名称. 按钮的大小是根据Gap来自动控制的
 segmentControl.delegate 实现后才能获知哪个按钮被点击了.
 segView.defaultSelectedIndex 可以用于设定初始被选中的按钮
 segmentControl.underlineShouldDisplay 用于是否显示下划线
 segmentControl.underlineWidthBoundToText 下划线宽度与文字等宽或者与按钮等宽
 segmentControl.buttonUnderlineGap 下划线与按钮或者文字之间的间隙
```

关于Gap:
![aa](/gap.png)
A: horizontalGap  
B: verticalGap  
C: buttonGap 
D: buttonUnderlineGap
