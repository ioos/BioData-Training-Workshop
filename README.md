# BioData-Training-Workshop - Python and R resources

R and Python resources for the [IOOS Biological Data Training Workshop (February 2018)](https://ioos.github.io/BioData-Training-Workshop/).

The workshop will rely heavily on R and Python for hands-on exercises and tools. We have set up R and Python instructions and resources to enable participants to set up environments for these programming languages both in participants' computers and on the cloud (via JupyterHub and RStudio). All these resources are accessible here, on this workshop GitHub repository.

*Note:* The [notebooks](https://github.com/ioos/BioData-Training-Workshop/tree/master/notebooks) GitHub repository directory contains a set of relevant, useful Jupyter notebooks that you can run and tweak, locally or on the cloud. These example notebooks cover Python, R and mixed-language cases.

## Click on the Binder badge below to start an interactive Jupyter seesion with the course notebooks.

[![Binder](http://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/ioos/BioData-Training-Workshop/master?filepath=notebooks)

## Setting up your local (your computer) Python and R environments

### Python
Please see [these instructions](https://github.com/ioos/BioData-Training-Workshop/blob/master/installation.md) for installing `conda` and the BioData-Training-Workshop conda environment in your computer. This conda environment will install:
- A fully capable Python 3 set of libraries that include packages relevant to the workshop and biological data. 
- Jupyter Notebooks
- R and R packages relevant to the workshop and biological data. But note that if you're already an R user and have R installed, you should use your usual R set up, with the additional instructions listed below.

**If you'd like python only environment, you can install `python-environment.yml`.**

### R

Use your own, pre-installed R installation. All of the R packages used in this workshop can be installed via the script [install-R-packages.R](https://github.com/ioos/BioData-Training-Workshop/blob/master/install-R-packages.R). The easiest way to execute this code is to paste the following line into the R Console:

```R
source("https://raw.githubusercontent.com/ioos/BioData-Training-Workshop/master/install-R-packages.R")
```

## Cloud-based R and Python environments

A cloud-based set up has been deployed to support the same capabilities available via the local set ups. This resources is a good option if you don't want to take the extra time required to set up R and/or Python on your computer.

### Python via JupyterHub

JupyterHub is a server-based version of Jupyter Notebooks that enable running Jupyter notebooks online. The JupyterHub set up for this workshop is found at https://ioosbiodata.cloudmaven.org. You will need to provide us your GitHub handle (account name) for access.

Within JupyterHub, select the `iooswkshp` conda environment ("kernel"), which is a full installation of the Python **and R** conda environment [`environment.yml`](https://github.com/ioos/BioData-Training-Workshop/blob/master/environment.yml) used in the local setup.

### R via RStudio

RStudio is available for launching from the JupyterHub interface. It comes with all of the packages within [`install-R-packages.R
`](https://github.com/ioos/BioData-Training-Workshop/blob/master/install-R-packages.R) already installed.
