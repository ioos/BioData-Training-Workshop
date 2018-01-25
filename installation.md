# Installing the BioData-Training-Workshop conda environment

## Install

Download and install the appropriate Miniconda Python 3.6 installer from [http://conda.pydata.org/miniconda.html](http://conda.pydata.org/miniconda.html).

Note that even though Miniconda Python 3.6 has Python 3.6 by default one can create environments with Python 2, R, etc from it.

### Windows

Run the installer
Choose *Just Me* (not *All Users*),
and choose a Install Location owned by you.

On the "Advanced Installation Options" screen,
leave the boxes checked if you want Miniconda 3 to be your default python.

Attention: if you are going to be switching to some other Python distribution,
it's best uncheck the boxes and use the `Anaconda Command Prompt` or `Anaconda Navigator` (see below for instructions) to start Anaconda.

### Linux/OS X

Copy-and-paste this:

```shell
if [[ $(uname) == "Darwin" ]]; then
  url=https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
elif [[ $(uname) == "Linux" ]]; then
  url=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi
curl $url -o miniconda.sh
bash miniconda.sh -b
export PATH=$HOME/miniconda3/bin:$PATH
```

We also recommend to add the following line to your `~/.bashrc` file to make Miniconda the Python found first than the system Python:

```
export PATH=$HOME/miniconda3/bin:$PATH
```

## Create the BioData-Training-Workshopenvironment

Download the [environment.yml](https://raw.githubusercontent.com/ioos/BioData-Training-Workshop/master/environment.yml) file by right clicking with the mouse and choosing `save as...`,
or, on `OS X` and `Linux`, use these commands to download:

```bash
url=https://raw.githubusercontent.com/ioos/BioData-Training-Workshop/master/environment.yml
curl $url -o environment.yml
```

Then from the directory where you saved the file above,
type the following commands in the terminal or Windows command prompt:

```bash
conda config --add channels conda-forge --force
conda update --yes --all
conda env create --name iooswkshp --file environment.yml
```

Once the environment is done building, you can activate it by typing:

```bash
activate iooswkshp  # Windows
source activate iooswkshp  # OS X and Linux
```

## Exiting the iooswkshp environment

If you want to leave the iooswkshp environment and return to the root environment,
you can type

```bash
deactivate  # Windows
source deactivate  # OS X and Linux
```

# If Miniconda is not your default python environment...

If you choose not to add Miniconda Python Distribution to your `~/.bashrc` or Windows path,
you must remember to activate the iooswkshp environment every time,
by typing in a command prompt

```
export PATH=$HOME/miniconda3/bin:$PATH && source activate iooswkshp  # OS X and Linux
```

Windows users can navigate to the Anaconda Command Prompt (e.g. Start Menu=>Anaconda3 on Windows 7) and type `activate iooswkshp`.

On all systems, to start the Jupyter notebook, just type:

```
jupyter notebook
```

