#!/usr/bin/env python3

import getopt, sys, os, subprocess

CONFIG = {}
# -1 =  Quiet           (No output at all)
# 0  =  Normal          (Only prints the final result)
# 1  =  Verbose         (Prints steps)
# 2  =  Very verbose    (Prints results for each tests)
# 3  =  Debug           (Prints std output and error output for each test)
CONFIG['verbose'] = 0
CONFIG['current_dir'] = os.path.dirname(os.path.abspath(__file__))
CONFIG['negative'] = CONFIG['current_dir'] + '/negative/'
CONFIG['positive'] = CONFIG['current_dir'] + '/positive/'
CONFIG['compiler_path'] = CONFIG['current_dir'] + '/../src/yang'
CONFIG['assembly_file_extension'] = '.s'

TESTS_LIST = {}

GLOBAL_RESULT = {}
GLOBAL_RESULT['positive_tests_passed'] = 0
GLOBAL_RESULT['positive_tests_partial_passed'] = 0
GLOBAL_RESULT['positive_tests_not_passed'] = 0
GLOBAL_RESULT['negative_tests_passed'] = 0
GLOBAL_RESULT['negative_tests_not_passed'] = 0


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def usage():
    '''Display usage.'''
    vprint("Usage: python run-tests OPTIONS", 0)


def parse_args():
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hvq", ["help"])
    except getopt.GetoptError as err:
        vprint(str(err), 0)
        usage()
        sys.exit(2)
    for o, a in opts:
        if o == "-v":
            CONFIG['verbose'] +=1
        elif o == "-q":
            CONFIG['verbose'] = -1
        elif o in ("-h", "--help"):
            usage()
            sys.exit()
        else:
            assert False, "unhandled option"


def textify_filename(filename):
    return filename.replace('.c', '').replace('_', ' ')


def vprint(string, level):
    if CONFIG['verbose'] >= level:
        print(string)


def init_tests_list():
    vprint("[~] Initializing tests list...", 1)

    for root, dirs, files in os.walk(CONFIG['positive']):
        TESTS_LIST['positive'] = []
        for filename in files:
            if filename.endswith('.c'):
                TESTS_LIST['positive'].append(filename)
    for root, dirs, files in os.walk(CONFIG['negative']):
        TESTS_LIST['negative'] = []
        for filename in files:
            if filename.endswith('.c'):
                TESTS_LIST['negative'].append(filename)

    vprint("[+] Tests list has been initialized", 2)


def run_single_test(directory, filename):
    path = CONFIG['current_dir']+"/{}/{}".format(directory, filename)

    if not os.path.isfile(CONFIG['compiler_path']):
        vprint("{}[ERROR] Compiler not found at {} {}".format(bcolors.FAIL, CONFIG['compiler_path'], bcolors.ENDC), 2)
        exit(-1)

    if not os.path.isfile(path):
        return False, None

    cat = subprocess.Popen(["cat", path], stdout=subprocess.PIPE)
    test = subprocess.Popen([CONFIG['compiler_path']], stdin=cat.stdout, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    out_text = test.stdout.read().decode('UTF-8')
    err_text = test.stderr.read().decode('UTF-8')

    result_test = (err_text == "")

    vprint("Result: {}".format(out_text), 3)
    vprint("Error: {}".format(err_text), 3)

    if path != CONFIG['positive']+"{}".format(filename):
        result_test = not result_test

    result_file = path.replace('.c', CONFIG['assembly_file_extension'])

    if not os.path.isfile(result_file):
        result_content = None
    else:
        with open(result_file, 'r') as content_file:
            content = content_file.read()
            result_content = (content == out_text)

    return result_test, result_content


def run_tests():
    vprint("[~] Running positive tests...", 1)

    for file in TESTS_LIST['positive']:
        test_success, correct_content = run_single_test('positive', file)

        if test_success and correct_content:
            GLOBAL_RESULT['positive_tests_passed'] += 1
        elif test_success and (correct_content is None):
            GLOBAL_RESULT['positive_tests_partial_passed'] += 1
        else:
            GLOBAL_RESULT['positive_tests_not_passed'] += 1

        str_test = bcolors.OKGREEN+"[SUCCESS]"+bcolors.ENDC if test_success else bcolors.FAIL+"[FAIL]  "+bcolors.ENDC
        if correct_content:
            str_content = bcolors.OKGREEN+"[SUCCESS]"+bcolors.ENDC
        elif correct_content is None:
            str_content = bcolors.WARNING+"[NYI]"+bcolors.ENDC
        else:
            str_content = bcolors.FAIL+"[FAIL]"+bcolors.ENDC

        test_name = " -  Running tests for '{}':".format(textify_filename(file))
        padded_test_name = test_name.ljust(80)
        status = "{}\t{}".format(str_test, str_content)
        vprint(padded_test_name + status, 2)

    vprint("[+] Running positive tests... Complete !", 1)
    vprint("[~] Running negative tests...", 1)

    for file in TESTS_LIST['negative']:
        test_success, correct_content = run_single_test('negative', file)

        if test_success:
            GLOBAL_RESULT['negative_tests_passed'] += 1
        else:
            GLOBAL_RESULT['negative_tests_not_passed'] += 1

        str_test = bcolors.OKGREEN+"[SUCCESS]"+bcolors.ENDC if test_success else bcolors.FAIL+"[FAIL]\t"+bcolors.ENDC

        test_name = " -  Running tests for '{}':".format(textify_filename(file))
        padded_test_name = test_name.ljust(80)
        status = "{}".format(str_test)
        vprint(padded_test_name + status, 2)

    vprint("[+] Running negative tests... Complete !", 1)


def get_result_table():
    total_positive = GLOBAL_RESULT['positive_tests_passed'] + GLOBAL_RESULT['positive_tests_partial_passed'] + GLOBAL_RESULT['positive_tests_not_passed']
    total_negative = GLOBAL_RESULT['negative_tests_passed'] + GLOBAL_RESULT['negative_tests_not_passed']
    total = total_positive + total_negative

    table = ""
    table += "-------------------------\n"
    table += "|         RESULTS      \t|\n"
    table += "-------------------------\n"
    table += "| Positive           {}\t|\n".format(total_positive)
    table += "| - passed           {}\t|\n".format(GLOBAL_RESULT['positive_tests_passed'])
    table += "| - partial (NYI)    {}\t|\n".format(GLOBAL_RESULT['positive_tests_partial_passed'])
    table += "| - failed           {}\t|\n".format(GLOBAL_RESULT['positive_tests_not_passed'])
    table += "|                      \t|\n"
    table += "| Negative           {}\t|\n".format(total_negative)
    table += "| - passed           {}\t|\n".format(GLOBAL_RESULT['negative_tests_passed'])
    table += "| - failed           {}\t|\n".format(GLOBAL_RESULT['negative_tests_not_passed'])
    table += "|                      \t|\n"
    table += "| Negative           {}\t|\n".format(total_negative)
    table += "| Total:             {}\t|\n".format(total)
    table += "-------------------------\n"

    return table


def main():
    parse_args()
    init_tests_list()
    run_tests()
    vprint(get_result_table(), 0)


if __name__ == "__main__":
    main()