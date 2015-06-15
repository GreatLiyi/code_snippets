# text
core text: c api, powerful
Text Kit: new in iOS 7, Objective-C API
UITextView: a lightweight drawing wrapper around text kit

## UIFont
- by name and size:  fontWithName:size:
- by functionality: systemFontOfSize:
- by intended usage(dynamic type font): preferredFontForTextStyle:

## use custom font
- add font file(ttf,otf) to project(supporting file)
- add a row to .plist 'Fonts provided by application', value is font file name
- get font using fontWithName:size:, get font name from OSX [Font Book] app
then you can use it

## use font descriptor to perform transformation
``` objective-c
UIFont *f=//
UIFontDescriptor *desc = [font fontDescriptor];
desc = [desc fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
f = [UIFont fontWithDescriptor:desc size:0];
```

## UILabel
