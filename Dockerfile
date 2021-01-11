FROM tensorflow/tensorflow:devel-gpu AS builder

RUN cd /tensorflow_src && git pull
RUN cd /tensorflow_src && ./configure

FROM tensorflow/tensorflow:latest-gpu-jupyter


