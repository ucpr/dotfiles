FROM denoland/deno:2.1.10

WORKDIR config

COPY . .

CMD ["bash"]
