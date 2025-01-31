FROM denoland/deno:2.1.8

WORKDIR config

COPY . .

CMD ["bash"]
