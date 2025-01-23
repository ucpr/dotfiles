FROM denoland/deno:2.1.7

WORKDIR config

COPY . .

CMD ["bash"]
