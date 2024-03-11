FROM denoland/deno:1.41.2

WORKDIR config

COPY . .

CMD ["bash"]
