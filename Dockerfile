FROM denoland/deno:2.7.8

WORKDIR config

COPY . .

CMD ["bash"]
