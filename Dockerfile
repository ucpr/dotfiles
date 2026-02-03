FROM denoland/deno:2.6.8

WORKDIR config

COPY . .

CMD ["bash"]
