from getpass import getpass
from os import remove as os_remove
from os.path import isfile, isdir
from base64 import b64encode, b64decode
import argparse
from myutil.crypto import aes
from myutil.file_utils import (path_to_obj, obj_to_file, compress_obj,
                               decompress_cobj, rec_remove)


def parse_args():
    parser = argparse.ArgumentParser(description='Run scraper')
    parser.add_argument('input_file_name')
    parser.add_argument('-e', '--encrypt', action='store_true')
    parser.add_argument('-d', '--decrypt', action='store_true')
    parser.add_argument('-o', '--output-file')
    parser.add_argument('-s', '--save-input', action='store_true',
                        help='save original file when encrypting a file')
    parser.add_argument('-r', '--remove-input', action='store_true',
                        help='toggles default for removing input file. If'
                        + ' encrypting the default is to remove, if decrypting'
                        + ' the default is to keep')
    return parser.parse_args(), parser.print_help


def main():
    args, print_help = parse_args()
    if validate_basic_args(args, print_help):
        process_args(args)


def validate_basic_args(args, print_help):
    if args.encrypt == args.decrypt:
        print('ERROR: must either choose to encrypt or decrypt')
        print_help()
        return False
    if not isfile(args.input_file_name) and not isdir(args.input_file_name):
        print('ERROR: input_file_name \'{}\' does not exist'
              .format(args.input_file_name))
        return False
    return True


def encrypt_data(input_file, output_file, pswd):
    obj = path_to_obj(input_file)
    data = compress_obj(obj)
    data = aes(pswd, data, True)
    with open(output_file, 'wb') as f:
        f.write(data)
    print('Successfully wrote file.')


def decrypt_data(input_file, output_file, pswd):
    with open(input_file, 'rb') as f:
        data = f.read()
    data = aes(pswd, data, False)
    if not data:
        print('ERROR: empty aes output, password wrong. Cancelling writing')
        return
    data = decompress_cobj(data)
    if output_file:
        data['name'] = output_file
        output_file = ''
    obj_to_file(data, output_file)
    print('Successfully wrote file.')


def handle_aes(input_file, output_file, pswd, encrypt):
    pswd = pswd.encode()
    if encrypt:
        encrypt_data(input_file, output_file, pswd)
    else:
        decrypt_data(input_file, output_file, pswd)


def output_target_exist(output_file, args):
    if isfile(output_file) and not args.output_file:
        print('ERROR: output target file \'{}\' already exist, if'
              .format(output_file),
              'you would like to overwrite the file please specify an',
              'output file destination using the -o flag')
        return True
    return False


def remove_input_file(args):
    if args.encrypt != args.remove_input:
        rec_remove(args.input_file_name)
        print('Successfully removed {} file \'{}\''
              .format('file' if isfile(args.input_file_name) else 'folder',
                      args.input_file_name))


def get_password(args):
    pswd = getpass('Password: ')
    pswd2 = getpass('Confirm password: ') if args.encrypt else ''

    return args.decrypt or pswd == pswd2, pswd


def get_output_file_name(args):
    if args.output_file:
        output_file = args.output_file
    else:
        if args.encrypt:
            output_file = args.input_file_name + '.aes'
        else:
            output_file = ''
    return output_file


def process_args(args):
    pswd_match, pswd = get_password(args)

    if not pswd_match:
        print('Passwords did not match')
        return

    output_file = get_output_file_name(args)

    if output_target_exist(output_file, args):
        return

    handle_aes(args.input_file_name, output_file, pswd, args.encrypt)
    remove_input_file(args)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nexiting...')
