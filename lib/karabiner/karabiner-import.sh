#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set private.f19ToCapsLock 1
/bin/echo -n .
$cli set private.F19ToshiftL 1
/bin/echo -n .
$cli set private.return2shiftR_return 1
/bin/echo -n .
$cli set private.shiftL2controlL 1
/bin/echo -n .
$cli set private.shiftR2controlR 1
/bin/echo -n .
$cli set repeat.initial_wait 416
/bin/echo -n .
$cli set repeat.wait 33
/bin/echo -n .
/bin/echo
