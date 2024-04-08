FROM python:latest

# https://huggingface.co/docs/hub/spaces-sdks-docker-first-demo
RUN useradd -m -u 1000 user

USER user

ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

WORKDIR $HOME/app

RUN CMAKE_ARGS="-DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS" pip install llama-cpp-python[server]==0.2.55 huggingface_hub[cli,hf_transfer]

RUN HF_HUB_ENABLE_HF_TRANSFER=1 \
	huggingface-cli download gingdev/ictu-vinallama-gguf ictu.gguf --local-dir . --local-dir-use-symlinks=True

EXPOSE 8000

ENTRYPOINT [ "python" ]

CMD [ "-m", "llama_cpp.server", "--model", "ictu.gguf", "--host", "0.0.0.0" ]
