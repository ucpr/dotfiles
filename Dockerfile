FROM denoland/deno:1.41.1

WORKDIR config

COPY . .

CMD ["bash"]
