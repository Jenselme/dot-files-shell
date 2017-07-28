#!/usr/bin/env python3

import sys
from glob import glob
from mailbox import mboxMessage
from os.path import join, splitext


path = '.'
if len(sys.argv) > 1:
    path = sys.argv[1]

for path in glob(join(path, '*.mbox')):
    with open(path, 'r') as mail_file:
        message = mboxMessage(mail_file.read())

    content = message.get_payload()
    if isinstance(content, str):
        html = message.get_payload(decode=True).decode('utf-8')
    else:
        html = content[0].get_payload(decode=True).decode('utf-8')
        html = html.replace('charset=iso-8859-1', 'charset=utf-8')

    file_name, _ = splitext(path)
    with open(f'{file_name}.html', 'w') as html_file:
        html_file.write(html)
    
