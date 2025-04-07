FROM denoland/deno:2.2.8

WORKDIR config

COPY . .

CMD ["bash"]
