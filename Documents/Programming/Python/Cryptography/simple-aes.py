import argparse
from myutil.crypto import aes
from base64 import b64encode, b64decode
from os.path import isfile
from os import remove as os_remove
from getpass import getpass


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


def process_args(args):
    pswd = getpass('Password: ')
    pswd2 = getpass('Confirm password: ') if args.encrypt else ''

    if args.encrypt and pswd != pswd2:
        print('Passwords did not match')
    else:
        if args.output_file:
            output_file = args.output_file
        else:
            if args.encrypt:
                output_file = args.input_file_name + '.aes'
            else:
                output_file = args.input_file_name.replace('.aes', '', 1)

        if isfile(output_file) and not args.output_file:
            print('ERROR: output target file \'{}\' already exist, if'
                  .format(output_file),
                  'you would like to overwrite the file please specify an',
                  'output file destination using the -o flag')
            return
        handle_aes(args.input_file_name, output_file, pswd, args.encrypt)
        if args.encrypt and not args.save_input:
            os_remove(args.input_file_name)
            print('Successfully removed input file \'{}\''
                  .format(args.input_file_name))


def main():
    parser = argparse.ArgumentParser(description='Run scraper')
    parser.add_argument('input_file_name')
    parser.add_argument('-e', '--encrypt', action='store_true')
    parser.add_argument('-d', '--decrypt', action='store_true')
    parser.add_argument('-o', '--output-file')
    parser.add_argument('-s', '--save-input', action='store_true',
                        help='keep original when encrypting a file')

    args = parser.parse_args()

    if args.encrypt == args.decrypt:
        print('ERROR: must either choose to encrypt or decrypt')
        parser.print_help()
    elif not isfile(args.input_file_name):
        print('ERROR: input_file_name \'{}\' does not exist'
              .format(args.input_file_name))
    else:
        process_args(args)


if __name__ == '__main__':
    main()
