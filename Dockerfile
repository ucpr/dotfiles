FROM denoland/deno:2.2.10

WORKDIR config

COPY . .

CMD ["bash"]
