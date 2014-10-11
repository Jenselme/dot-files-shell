#!/usr/bin/ipython3

a = !ls
# Les variables contiennent des espaces, on les entoure donc avec des guillements
cmd = 'ffmpeg -i "{}" -vn -ar 44100 -ac 2 -ab 128k -f ogg -acodec libvorbis "{}".ogg'
for file in a:
    os.system(cmd.format(file, file[:-5]))
