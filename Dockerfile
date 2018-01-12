FROM lsetiawan/jnrstud-minimal:latest

MAINTAINER Landung Setiawan <landungs@uw.edu>

USER root

RUN apt-get update && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*;

USER $NB_USER

COPY . /home/$NB_USER/

USER root

# Install Python 3 packages
RUN conda env create --file /home/$NB_USER/environment.yml && \
    conda install -c conda-forge --quiet --yes \
    'nb_conda_kernels' \
    'ipykernel' \
    'ipywidgets' && \
    conda clean -tipsy && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix;

RUN rm -rf /home/$NB_USER/work;

RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook

USER $NB_USER

