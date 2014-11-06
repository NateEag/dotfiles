// Set up [Slate](https://github.com/jigish/slate) window layouts based on
// Emacs window size.
//
// I use Emacs for programming, writing, and typesetting music. Thus, it's the
// primary feature in most of my workspaces.
//
// My Emacs config chooses the best font size/window size/window structure for
// me based on the resolution and pixel density of my current display.
//
// Thus, the usual Slate config style of defining layouts in terms of 'fraction
// of the screen' doesn't work for me. I need to define my layouts relative to
// Emacs, due to the dynamic window size.
//
// This is WIP, and doesn't really work well. I've seen people grumble about
// Slate responsiveness, and based on experience hacking on it, I think it gets
// bad when you enable JS config.

var emacsWindowSize;
var screenRect;

function getEmacsWindowSize() {
    var focusedApp = slate.app();

    var focusOp = slate.operation('focus', {app: 'Emacs'});
    focusOp.run();

    var emacsWindow = slate.window();
    emacsWindowSize = emacsWindow.size();

    var restoreFocusOp = slate.operation('focus', {app: focusedApp.name()});
    restoreFocusOp.run();
}
getEmacsWindowSize();

function getScreenRect() {
    var screen = slate.screen();
    screenRect = screen.rect();
}
getScreenRect();

// Rewrite this to do the operations manually, instead of using layout.
//
// The layout method has some nice abstractions, but it looks like there's no
// way to use a JS variable to update a layout operation's width. Only way to
// adjust it dynamically is with Slate expressions, and they won't do what I
// need.
//
// For the moment, I just have to restart Slate each time I want to apply this
// layout. Two keychords instead of one, so not the end of the world.
//
var webDevLayout = slate.layout('WebDev', {
    // DEBUG Irrelevant, since the closured variables don'
    // Make sure window/screen size variables are up-to-date.
    // _before_: {
    //     operations: [
    //         getEmacsWindowSize,
    //         getScreenRect
    //     ]
    // },
    Emacs: {
        operations: [
            slate.operation('corner', {
                direction: 'top-left'
            })
        ]
    },
    'Google Chrome': {
        operations: [
            slate.operation('corner', {
                direction: 'top-right',
                width: screenRect.width - emacsWindowSize.width - 10,
                height: 'screen'
            })
        ]
    },
    Slack: {
        operations: [
            slate.operation('corner', {
                direction: 'bottom-right',
                width: screenRect.width - emacsWindowSize.width - 10
            })
        ]
    }
});

slate.bind('3:ctrl,shift', function() {
    var layoutOp = slate.operation('layout', {
        name: 'WebDev'
    });

    layoutOp.run();
});
