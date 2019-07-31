#!/usr/bin/env bash







# restart jupyter lab
sudo initctl restart jupyter-server --no-wait

## list environments
# conda info --envs




   78  pip install numpy
   79  pip install flask
   80  pip install bokeh
   81  pip install psutil
   82  pip install pandas
   83  pip install holoviews
   84  pip install ipywidgets
   85  pip install "jupyterlab>=1.0" jupyterlab-dash==0.1.0a3

nohup /home/ec2-user/anaconda3/bin/conda remove --name R_Beta --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name amazonei_mxnet_p27 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name amazonei_mxnet_p36 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name amazonei_tensorflow_p27 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name amazonei_tensorflow_p36 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name chainer_p27 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name chainer_p36 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name mxnet_p27 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name mxnet_p36 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name python2 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name python3 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name pytorch_p27 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name pytorch_p36 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name tensorflow_p27 --quiet --yes --all &
nohup /home/ec2-user/anaconda3/bin/conda remove --name tensorflow_p36 --quiet --yes --all &



# source global jupyter environment
source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
pip install pip --upgrade
pip install jupyter --upgrade
pip install jupyterlab --upgrade
initctl restart jupyter-server
jupyter labextension update --all -y --no-build
jupyter labextension install jupyterlab_bokeh --no-build -y
jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build -y
jupyter lab build
initctl restart jupyter-server --no-wait
source /home/ec2-user/anaconda3/bin/deactivate

/home/ec2-user/anaconda3/bin/conda create -n rgs python=3.7 ipykernel bokeh numpy flask psutil pandas holoviews ipywidgets --yes
/home/ec2-user/anaconda3/bin/conda activate rgs
# source activate rgs
ipython kernel install --user --name=rgs_py37
/home/ec2-user/anaconda3/bin/conda deactivate
initctl restart jupyter-server --no-wait


# remove environment

# create environment


# deactivate global jupyter environment





# extensions
@jupyter-widgets/jupyterlab-manager

@jupyterlab/plotly-extension

@jupyterlab/htmlviewer-extension




bash
conda activate rgs
(rgs)$ conda install ipykernel
(rgs)$ ipython kernel install --user --name=rgs_py37
(rgs)$ conda deactivate

source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
jupyter labextension install jupyterlab_bokeh
jupyter labextension update --all

jupyter labextension install @jupyter-widgets/jupyterlab-manager