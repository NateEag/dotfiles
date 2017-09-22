#!/usr/bin/env python

# Functions for use with offlineimap.

import re
import os
import sys
import subprocess


def get_authinfo_password(machine, login):
    "Return decrypted password from .authinfo.gpg."

    s = 'machine %s login %s password "([^"]*)"' % (machine, login)
    pattern = re.compile(s)

    authinfo = os.popen("gpg -q -d ~/.authinfo.gpg").read()
    match = pattern.search(authinfo)

    return match.group(1)


def get_keychain_pass(account=None, server=None):
    """Semi-securely retrieve password from OS X keychain."""

    params = {
        'security': '/usr/bin/security',
        'command': 'find-internet-password',
        'account': account,
        'server': server,
        'keychain': '/Users/nate/Library/Keychains/login.keychain',
    }
    command = "sudo -u nate %(security)s -v %(command)s -g -a %(account)s -s %(server)s %(keychain)s" % params
    output = subprocess.check_output(command, shell=True, stderr=subprocess.STDOUT)
    outtext = [l for l in output.splitlines()
               if l.startswith('password: ')][0]

    return re.match(r'password: "(.*)"', outtext).group(1)

if __name__ == '__main__':
    password = get_authinfo_password(sys.argv[2], sys.argv[1])
    sys.stdout.write(password)
