FROM denoland/deno:2.9.8

WORKDIR config

COPY . .

CMD ["bash"]
