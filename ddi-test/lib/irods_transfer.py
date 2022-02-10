from irods.session import iRODSSession
import irods.exception as iRODSExceptions
from irods.access import iRODSAccess
import os
import sys
import time
import humanize
import logging


def has_subcollection(collection):
    if len(collection.subcollections) == 0:
        return False
    return True


def has_objects(coll):
    if (len(coll.data_objects) == 0):
        return False
    return True


def line_out(s):
    # http://www.termsys.demon.co.uk/vtansi.htm
    logging.info('\x1b[2K\r')
    logging.info(str(s))


def iget(session, source_path):
    coll = session.collections.get(source_path)
    temp = coll.name
    os.mkdir(temp)
    os.chdir(temp)
    if has_objects(coll):
        for obj in coll.data_objects:
            window_start = 0.0
            window_bytes = 0.0
            total_bytes = 0
            average_rate = 0.0
            check_interval = 1.0
            dirpath = os.getcwd() + "/" + obj.name
            with obj.open('r') as f_in:
                chunk_size = 2 * 1024 * 1024
                with open(dirpath, 'wb') as f_out:
                    window_start = time.time()
                    while True:
                        chunk = f_in.read(chunk_size)
                        if len(chunk) <= 0:
                            break
                        total_bytes += len(chunk)
                        window_bytes += len(chunk)
                        f_out.write(chunk)
                        curr_time = time.time()
                        if curr_time >= window_start + check_interval:
                            average_rate = 0.6 * average_rate + 0.4 * (window_bytes / (curr_time - window_start))
                            line_out('Total transferred: {} B ({}), Approximate Current Rate: {} B/s ({}/s)'.format(
                                total_bytes, humanize.naturalsize(total_bytes, binary=True),
                                int(average_rate), humanize.naturalsize(average_rate, binary=True)))
                            window_start = time.time()
                            window_bytes = 0.0
    if has_subcollection(coll):
        for col in coll.subcollections:
            iget(session, col.path)
            os.chdir("../..")


def iget_object(session, source_path):
    sys.stdout.write("XX")
    obj = session.data_objects.get(source_path)
    sys.stdout.write("AA")
    window_start = 0.0
    window_bytes = 0.0
    total_bytes = 0
    average_rate = 0.0
    check_interval = 1.0  # seconds
    dirpath = os.getcwd() + "/" + obj.name
    sys.stdout.write("BB")
    with obj.open('r') as f_in:
        chunk_size = 2 * 1024 * 1024
        with open(dirpath, 'wb') as f_out:
            window_start = time.time()
            while True:
                sys.stdout.write("CC")
                chunk = f_in.read(chunk_size)
                if len(chunk) <= 0:
                    break
                total_bytes += len(chunk)
                window_bytes += len(chunk)
                f_out.write(chunk)
                curr_time = time.time()
                if curr_time >= window_start + check_interval:
                    average_rate = 0.6 * average_rate + 0.4 * (window_bytes / (curr_time - window_start))
                    line_out('Total transferred: {} B ({}), Approximate Current Rate: {} B/s ({}/s)'.format(
                        total_bytes, humanize.naturalsize(total_bytes, binary=True),
                        int(average_rate), humanize.naturalsize(average_rate, binary=True)))
                    window_start = time.time()
                    window_bytes = 0.0


def initiate_irods_to_staging_zone_transfer(session, source_path, target_path):
    print(target_path)
    try:
        os.chdir(target_path)
    except:
        raise NotADirectoryError
    #    try:
    try:
        sys.stdout.write("A " + source_path)
        pcoll = session.collections.get(source_path)
        sys.stdout.write("B")
        iget(session, source_path)
        sys.stdout.write("C")
    except iRODSExceptions.CollectionDoesNotExist:
        sys.stdout.write("D")
        iget_object(session, source_path)
        sys.stdout.write("E")
    except:
        sys.stdout.write("F")
        raise (Exception("Irods path does not exist"))


def iput(session, source_path, target_path):
    for root, subdirs, files in os.walk(source_path):

        temp_path = (root.split(os.path.dirname(source_path)))[1]
        root_dir = target_path + temp_path
        temp_root_dir = session.collections.create(root_dir)
        # +-print(temp_root_dir.path)
        for subdir in subdirs:
            temp = session.collections.create(root_dir + "/" + subdir)
            acl_project = iRODSAccess('inherit', temp)
            session.permissions.set(acl_project)
        for filename in files:
            print(root_dir + "/" + filename)
            obj = session.data_objects.create(root_dir + "/" + filename)
            window_start = 0.0
            window_bytes = 0.0
            total_bytes = 0
            average_rate = 0.0
            check_interval = 1.0  # seconds
            dirpath = root + "/" + filename
            with obj.open('r+') as f_out:
                chunk_size = 2 * 1024 * 1024
                with open(dirpath, 'rb') as f_in:
                    window_start = time.time()
                    while True:
                        chunk = f_in.read(chunk_size)
                        if len(chunk) <= 0:
                            break
                        total_bytes += len(chunk)
                        window_bytes += len(chunk)
                        f_out.write(chunk)
                        curr_time = time.time()
                        if curr_time >= window_start + check_interval:
                            average_rate = 0.6 * average_rate + 0.4 * (window_bytes / (curr_time - window_start))
                            line_out('Total transferred: {} B ({}), Approximate Current Rate: {} B/s ({}/s)'.format(
                                total_bytes, humanize.naturalsize(total_bytes, binary=True),
                                int(average_rate), humanize.naturalsize(average_rate, binary=True)))
                            window_start = time.time()
                            window_bytes = 0.0


def delete_coll(session, coll_path):
    dataset = session.collections.get(coll_path)
    dataset.remove()
