#!/usr/bin/env python

# Functions for use with offlineimap.

import re
import subprocess


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
    get_keychain_pass('nate4d@gmail.com', 'imap.gmail.com')
