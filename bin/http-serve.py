#!/usr/bin/env python3

import argparse
import logging
import mimetypes
import os
import re
import aiofiles

from glob import glob
from stat import S_ISDIR
from aiofiles import os as aios
from aiohttp import web
from aiohttp.web_urldispatcher import (
    ResourceRoute,
    UrlDispatcher,
    UrlMappingMatchInfo,
)


class UrlToPathDispatcher(UrlDispatcher):
    '''The gaol of this dispatcher is to load URLs like /images/world.png as path instead of routes.
    '''
    async def resolve(self, request):
        return UrlMappingMatchInfo({}, ResourceRoute('GET', read_static, self))


async def read_static(request):
    # Remove first slash to the page is correctly interpreted as a sub path of the current directory.
    path = re.sub('^/', '', request.path)
    # Replace empty path by current directory.
    path = path if path else '.'
    if not await is_path_valid(path):
        logging.error(f'{path} is empty, does not exist or is not in the current directory')
        raise web.HTTPNotFound()

    if await is_directory(path):
        return await serve_directory_or_index(path)

    return await serve_file(path)


async def is_path_valid(path: str) -> bool:
    if path is None:
        return False
    return await in_subdir(path) and await exists(path)


async def in_subdir(path: str) -> bool:
    path = os.path.join(os.getcwd(), path)
    path = os.path.normpath(path)
    return path.startswith(os.getcwd())


async def exists(path: str) -> bool:
    try:
        await aios.stat(path)
    except FileNotFoundError:
        return False
    else:
        return True


async def is_directory(path: str) -> bool:
    stat = await aios.stat(path)
    return S_ISDIR(stat.st_mode)


async def serve_directory_or_index(path: str) -> web.Response:
    if await has_index(path):
        return await serve_file(os.path.join(path, 'index.html'))

    return await serve_directory(path)


async def has_index(path: str) -> bool:
    return await exists(os.path.join(path, 'index.html'))


async def serve_file(path: str) -> web.Response:
    async with aiofiles.open(path, mode='rb') as f:
        content = await f.read()
        filename = os.path.basename(path)
        content_type, charset = mimetypes.guess_type(filename)
        return web.Response(
            body=content,
            content_type=content_type,
            charset=charset,
            headers={
                'Content-Disposition': f'inline; filename="{filename}"'
            },
        )


async def serve_directory(path: str) -> web.Response:
    files = glob(os.path.join(path, '*'))
    title = '/' if path == '.' else path
    content = f'<h1>Listing under <em>{title}</em></h1> <ul>'

    for file in files:
        content += f'<li><a href="{file}">{file}</a></li>'

    content += '</ul>'

    return web.Response(text=content, content_type='text/html')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--port', '-p',
        help='The port of which to launch the server',
        default=8000,
        type=int,
    )
    args = parser.parse_args()

    app = web.Application(router=UrlToPathDispatcher())
    app.router.add_get('/', read_static)

    web.run_app(app, port=args.port)


if __name__ == '__main__':
    main()

