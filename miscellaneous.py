#### Miscellaneous functions that can be used in any script ####

import os
import inspect
import subprocess

def comp_identifier():

    #"""Determines whether the user's machine is a PC or mac."""
    script_dir = os.path.dirname(os.path.abspath(
        inspect.getfile(inspect.currentframe())))  # script directory
    first_char_id = script_dir[0]

    if first_char_id == '/':
        comp_type = 'mac'
        script_dir = os.path.dirname(os.path.abspath(
            inspect.getfile(inspect.currentframe()))).replace('/modules', '')
    else:
        comp_type = 'pc'
        script_dir = os.path.dirname(os.path.abspath(
            inspect.getfile(inspect.currentframe()))).replace('\\modules', '')

    return first_char_id, comp_type, script_dir


first_char_id, comp_type, script_dir = comp_identifier()


def path_setter(script_dir, comp_type=comp_type, path_elems=[], char_trim=0):

    #"""This is an easy way of 'path setting' for PCs and Macs alike.
    #Note that the char_trim argument must be the length of the word/
    #sum of words and additional '/' characters in the part of the path
    #that you're trying to eliminate -- no longer."""

    # Eliminates the part of the path you specify
    if (char_trim > 0) & (comp_type == 'mac'):
        script_dir = script_dir[:-(char_trim)]
    elif (char_trim > 0) & (comp_type == 'pc'):
        script_dir = script_dir[:-(char_trim + 1)]
    elif char_trim < 0:
        raise(ValueError(
            "You aren't using the 'char_trim' argument properly. Follow the rules, you naughty sailor."))

    if comp_type == 'mac':
        for elem_ind in range(len(path_elems)):
            script_dir += '/' + path_elems[elem_ind]
    else:
        for elem_ind in range(len(path_elems)):
            script_dir += '\\' + path_elems[elem_ind]

    return script_dir


def subprocess_call(script, script_dir, comp_type=comp_type):

    if comp_type == 'mac':
        path = path_setter(script_dir=script_dir,
                           comp_type=comp_type, path_elems=[script])
        subprocess.run(['/Library/Frameworks/R.framework/Resources/bin/Rscript',
                        path],
                       universal_newlines=True)
    else:
        path = path_setter(script_dir=script_dir,
                           comp_type=comp_type, path_elems=[script])
        try:
            poss_versions = ['R-3.5.' + str(x) for x in range(0, 10)]
            r_path = 'C:/Program Files/R/{}/bin/Rscript'
            for poss_version in poss_versions:
                filename = r_path.format(poss_version)
                try:
                    subprocess.run([filename,
                                    '--vanilla',
                                    path],
                                   universal_newlines=True)
                except FileNotFoundError:
                    continue
        except FileNotFoundError:
            raise Exception("Please make sure you have R version 3.5.0 or greater installed on your system "
                            "or the model will not run."
                            "The program should be stored at C:/Program Files/R/R-3.5._")
