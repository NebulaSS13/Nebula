import sys
import re

def green(text):
    return "\033[32m" + str(text) + "\033[0m"

def red(text):
    return "\033[31m" + str(text) + "\033[0m"

def annotate(raw_output):
    # Remove ANSI escape codes
    raw_output = re.sub(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]', '', raw_output)

    print("::group::OpenDream Output")
    print(raw_output)
    print("::endgroup::")

    annotation_regex = r'((?P<type>Error|Warning) (?P<errorcode>OD(?P<errornumber>\d{4})) at (?P<location>(?P<filename>.+):(?P<line>\d+):(?P<column>\d+)|<internal>): (?P<message>.+))'
    failures_detected = False

    print("OpenDream Code Annotations:")
    for annotation in re.finditer(annotation_regex, raw_output):
        message = annotation['message']
        if message == "Unimplemented proc & var warnings are currently suppressed": # this happens every single run, it's important to know about it but we don't need to throw an error
            message += " (This is expected and can be ignored)" # also there's no location for it to annotate to since it's an <internal> failure.

        if annotation['type'] == "Error":
            failures_detected = True

        error_string = f"{annotation['errorcode']}: {message}"

        if annotation['location'] == "<internal>":
            print(f"::{annotation['type']} file=,line=,col=::{error_string}")
        else:
            print(f"::{annotation['type']} file={annotation['filename']},line={annotation['line']},col={annotation['column']}::{error_string}")

    if failures_detected:
        sys.exit(1)
        return

    print(green("No OpenDream issues found!"))

annotate(sys.stdin.read())
