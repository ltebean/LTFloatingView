
## Demo

![LTFloatingView](https://raw.githubusercontent.com/ltebean/LTFloatingView/master/demo.gif)

## Usage

#### 1. Create the floating view
Create the view by:
```objective-c
self.floatingView = [[LTFloatingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
[self.view addSubview:self.floatingView];

```
Or you can directly put it in the storyboard.

#### 2. Config the floating view

Config the floating view by:
```objective-c
[self.floatingView registerViewClass:[UILabel class]];
self.floatingView.stayingSeconds = 4;
self.floatingView.viewSpacing = 5;
self.floatingView.delegate = self;
```

Then implement the delegate, here the view class is the one you set in `registerViewClass`, the data is what you pushed to the queue(see #3)
```objective-c
- (void)configureView:(UIView *)view withData:(id)data
{
    UILabel *label = (UILabel *)view;
    NSString *text = (NSString *)data;
    
    label.frame = CGRectMake(10, 0, 150, 30);
    label.textColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor blackColor];
    label.text = text;
}
```

#### 3. Push data to display

You can push the data to the queue by:
```objective-c
[self.floatingView pushDataToLast:@"1"];
[self.floatingView pushDataToFirst:@"2"];
```

