FROM tensorflow/tensorflow:devel-gpu AS builder

RUN cd /tensorflow_src && git pull

ENV TF_NEED_CUDA 1
ENV TF_CUDA_COMPUTE_CAPABILITIES 7.5

ENV USE_DEFAULT_PYTHON_LIB_PATH 1

RUN cd /tensorflow_src && \
      ./configure && \
      bazel build --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package && \
      ./bazel-bin/tensorflow/tools/pip_package/build_pip_package ./

FROM tensorflow/tensorflow:latest-gpu-jupyter

COPY --from=builder /tensorflow_src/tensorflow-*.whl /tensorflow-new.whl

RUN pip uninstall tensorflow
RUN pip install /tensorflow-new.whl
RUN rm /tensorflow-new.whl

WORKDIR /workspace
ENTRYPOINT ["/usr/bin/jupyter-lab"]
