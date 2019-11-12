import argparse
from myutil.crypto import aes
from base64 import b64encode, b64decode
from os.path import isfile
from os import remove as os_remove
from getpass import getpass


def parse_args():
    parser = argparse.ArgumentParser(description='Run scraper')
    parser.add_argument('input_file_name')
    parser.add_argument('-e', '--encrypt', action='store_true')
    parser.add_argument('-d', '--decrypt', action='store_true')
    parser.add_argument('-o', '--output-file')
    parser.add_argument('-s', '--save-input', action='store_true',
                        help='save original file when encrypting a file')
    return parser.parse_args(), parser.print_help


def validate_basic_args(args, print_help):
    if args.encrypt == args.decrypt:
        print('ERROR: must either choose to encrypt or decrypt')
        print_help()
        return False
    if not isfile(args.input_file_name):
        print('ERROR: input_file_name \'{}\' does not exist'
              .format(args.input_file_name))
        return False
    return True


def handle_aes(input_file, output_file, pswd, encrypt):
    with open(input_file, 'rb') as f:
        data = f.read()

    aes_data = aes(pswd.encode(), data, encrypt=encrypt)

    if not aes_data and not encrypt:
        print('ERROR: empty aes output, password wrong. Cancelling writing')
        return

    with open(output_file, 'wb') as f:
        f.write(aes_data)

    print('\nSuccessfully wrote file.')


def output_target_exist(output_file, args):
    if isfile(output_file) and not args.output_file:
        print('ERROR: output target file \'{}\' already exist, if'
              .format(output_file),
              'you would like to overwrite the file please specify an',
              'output file destination using the -o flag')
        return True
    return False


def remove_input_file(args):
    if args.encrypt and not args.save_input:
        os_remove(args.input_file_name)
        print('Successfully removed input file \'{}\''
              .format(args.input_file_name))


def get_output_file_name(args):
    if args.output_file:
        output_file = args.output_file
    else:
        if args.encrypt:
            output_file = args.input_file_name + '.aes'
        else:
            output_file = args.input_file_name.replace('.aes', '', 1)
    return output_file


def get_password(args):
    pswd = getpass('Password: ')
    pswd2 = getpass('Confirm password: ') if args.encrypt else ''

    return args.decrypt or pswd == pswd2, pswd


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


def main():
    args, print_help = parse_args()
    if validate_basic_args(args, print_help):
        process_args(args)


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nexiting...')
