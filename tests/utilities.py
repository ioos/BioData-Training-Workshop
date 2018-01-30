"""
Notebooks tests
----------------

Common utilities functions.

"""

import os

from nbconvert import PythonExporter
from nbconvert.exporters import Exporter
from nbconvert.preprocessors import ExecutePreprocessor


kernels = {
    'R': 'ir',
    'octave': 'octave',
    'matlab': 'octave',
    'python': 'python',
    'python2': 'python',
    'python3': 'python',
}

_root_path = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))


def load_notebook(fname):
    notebook, resources = Exporter().from_filename(fname)
    return notebook, resources


def get_language(notebook):
    return notebook['metadata']['kernelspec']['language']


def convert_to_python(notebook, template_file=None):
    exporter = PythonExporter()
    exporter.template_file = template_file
    notebook_code, meta = exporter.from_notebook_node(notebook)
    return notebook_code, meta


def notebook_tester(fname, kernelspec='python'):
    raw_nb = Exporter().from_filename(fname)
    raw_nb[0].metadata.setdefault('kernelspec', {})['name'] = kernelspec
    preproc = ExecutePreprocessor(timeout=-1)
    preproc.preprocess(*raw_nb)


def test_run(fname):
    notebook, _ = load_notebook(fname)
    language = get_language(notebook)
    kernelspec = kernels[language]
    # FIXME: we cannot run MatlabTM/Octave on Travis yet.
    if kernelspec == 'octave':
        print('Cannot run {} with kernel {}'.format(fname, language))
    else:
        notebook_tester(fname, kernelspec=kernelspec)
