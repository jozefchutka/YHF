# TODO
- test performance with observing
- focus management
- layout
- simple width, height
- simple x, y via transform matrix
- css definition from template
- binding via Object.observe()

## Unit Test
- FocusUtil.addFocusListener, addBlurListener
- test onfocused event is dispatched
- custom event can be dispatched, bubbles
- event would bubble even outside document (see issue)

# Known Issues
- on Chrome event would not bubble from child if parent is not in document https://code.google.com/p/chromium/issues/detail?id=120494
- on IE11 removing a Text node would dispatch two observed mutations

# Support
IE9+
Chrome
FireFox
Safari

## IE8
- missing addEventListener - fixable
- missing global Node object - unknown solution