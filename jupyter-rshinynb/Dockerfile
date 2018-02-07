FROM rocker/geospatial:latest

MAINTAINER Landung Setiawan <landungs@uw.edu>

USER root

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini



ENV CONDA_DIR /opt/conda
ENV SHELL /bin/bash
ENV NB_USER rstudio
ENV NB_UID 1000

RUN mkdir -p $CONDA_DIR && \
    chown $NB_USER $CONDA_DIR

USER ${NB_USER}


# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION 4.3.21
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "c1c15d3baba15bf50293ae963abef853 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda update --all && \
    $CONDA_DIR/bin/conda clean -tipsy

# Set ENV for all programs...
ENV PATH ${CONDA_DIR}/bin:${PATH}

RUN git clone https://github.com/ioos/BioData-Training-Workshop.git /home/${NB_USER}/build_files

ENV BUILD_FILES /home/${NB_USER}/build_files

# Install Jupyter Notebook and Hub
RUN $CONDA_DIR/bin/conda install -c conda-forge --quiet --yes \
    'notebook=5.2.*' \
    'jupyterhub=0.8.*' \
    'jupyterlab' \
    'nb_conda_kernels' \
    'ipykernel' \
    'ipywidgets' \
    && $CONDA_DIR/bin/conda env create --file ${BUILD_FILES}/jupyter-rshinynb/environment.yml \
    && $CONDA_DIR/bin/conda clean -tipsy

RUN Rscript ${BUILD_FILES}/install-R-packages.R

ENV HOME /home/${NB_USER}
WORKDIR ${HOME}

USER root

RUN apt-get update && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# And set ENV for R! It doesn't read from the environment...
RUN echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron

# The `rsession` binary that is called by nbrsessionproxy to start R doesn't seem to start
# without this being explicitly set
ENV LD_LIBRARY_PATH /usr/local/lib/R/lib

RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook

USER ${NB_USER}

RUN $CONDA_DIR/bin/pip install pip==9.0.1
RUN ls -la /opt/conda/lib/python3.6/site-packages/ && $CONDA_DIR/bin/pip install nbrsessionproxy

RUN $CONDA_DIR/bin/jupyter serverextension enable --sys-prefix --py nbrsessionproxy && \
    $CONDA_DIR/bin/jupyter nbextension install    --sys-prefix --py nbrsessionproxy && \
    $CONDA_DIR/bin/jupyter nbextension enable     --sys-prefix --py nbrsessionproxy

RUN $CONDA_DIR/bin/pip install git+https://github.com/data-8/nbgitpuller

USER root

EXPOSE 8888
WORKDIR $HOME

# Configure container startup
ENTRYPOINT ["tini", "--"]
CMD ["start-notebook.sh"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/
RUN chown -R $NB_USER:$NB_UID /etc/jupyter/
RUN chmod -R +x /usr/local/bin/

# Cleanup
RUN rm -rf ${BUILD_FILES}

USER $NB_USER