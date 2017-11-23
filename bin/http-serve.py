#!/usr/bin/env python3

import logging
import mimetypes
import os
import aiofiles

from stat import S_ISDIR
from aiofiles import os as aios
from aiohttp import web


async def read_static(request):
    text = "Hello World!"
    path = request.query.get('path')
    if not await is_path_valid(path):
        logging.error(f'{path} is empty, does not exist or is not in the current directory')
        raise web.HTTPNotFound()

    if await is_directory(path):
        raise web.HTTPNotImplemented()

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


if __name__ == '__main__':
    app = web.Application()
    app.router.add_get('/', read_static)

    web.run_app(app, port=9292)
